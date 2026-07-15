const DEFAULT_SAMPLE_RATE = 44100;
const DEFAULT_CHANNELS = 2;
const INIT_TIMEOUT_MS = 30_000;

function newRequestId() {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID();
  }
  return `req-${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

export class RenderService {
  constructor(workerUrl, { sampleRate = DEFAULT_SAMPLE_RATE, channels = DEFAULT_CHANNELS } = {}) {
    this.worker = new Worker(workerUrl, { type: 'module' });
    this.sampleRate = sampleRate;
    this.channels = channels;
    this.initPromise = null;
    this.activeRequestId = null;
    this.activeReject = null;
    this.activeCleanup = null;
  }

  async init() {
    if (!this.initPromise) {
      this.initPromise = this.call({
        type: 'INIT',
        sampleRate: this.sampleRate,
        channels: this.channels,
      }, {
        okType: 'INIT_OK',
        errorType: 'INIT_ERROR',
        timeoutMs: INIT_TIMEOUT_MS,
      }).then(() => undefined);
    }

    return this.initPromise;
  }

  async prepareTrack(trackId, fileName, data) {
    await this.init();
    this.cancelActiveRequest();

    const requestId = newRequestId();
    const payload = {
      type: 'PREPARE_TRACK',
      requestId,
      trackId,
      fileName,
      data,
    };

    return this.call(payload, {
      okType: 'PREPARE_OK',
      errorType: 'PREPARE_ERROR',
      transfer: [data],
      requestId,
      timeoutMs: 60_000,
    }).then((response) => response.prepared);
  }

  async renderMasked(trackId, ayRegsTrace, channelMask) {
    await this.init();
    this.cancelActiveRequest();

    const requestId = newRequestId();
    return this.call({
      type: 'RENDER_MASKED',
      requestId,
      trackId,
      ayRegsTrace,
      channelMask,
    }, {
      okType: 'PREPARE_OK',
      errorType: 'PREPARE_ERROR',
      requestId,
      timeoutMs: 60_000,
    }).then((response) => response.prepared);
  }

  cancelActiveRequest() {
    if (!this.activeRequestId) {
      return;
    }

    this.worker.postMessage({
      type: 'CANCEL_REQUEST',
      requestId: this.activeRequestId,
    });

    this.activeCleanup?.();
    this.activeReject?.(new Error('PREPARE_CANCELLED'));
    this.activeRequestId = null;
    this.activeReject = null;
    this.activeCleanup = null;
  }

  call(message, { okType, errorType, transfer = [], requestId = null, timeoutMs = 30_000 }) {
    return new Promise((resolve, reject) => {
      let timeoutId = null;

      const cleanup = () => {
        this.worker.removeEventListener('message', onMessage);
        this.worker.removeEventListener('error', onError);

        if (timeoutId !== null) {
          clearTimeout(timeoutId);
          timeoutId = null;
        }

        if (this.activeRequestId === requestId) {
          this.activeRequestId = null;
          this.activeReject = null;
          this.activeCleanup = null;
        }
      };

      const onMessage = (event) => {
        const data = event.data;

        if (requestId && 'requestId' in data && data.requestId !== requestId) {
          return;
        }

        if (data.type === okType) {
          cleanup();
          resolve(data);
          return;
        }

        if (data.type === errorType) {
          cleanup();
          reject(new Error(data.internalReason || data.code || errorType));
        }
      };

      const onError = () => {
        cleanup();
        reject(new Error('WORKER_TRANSPORT_ERROR'));
      };

      if (requestId) {
        this.activeRequestId = requestId;
        this.activeReject = reject;
        this.activeCleanup = cleanup;
      }

      timeoutId = setTimeout(() => {
        cleanup();
        reject(new Error('TIMEOUT'));
      }, timeoutMs);

      this.worker.addEventListener('message', onMessage);
      this.worker.addEventListener('error', onError);
      this.worker.postMessage(message, transfer);
    });
  }
}
