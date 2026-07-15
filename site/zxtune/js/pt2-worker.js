const EXTENSIONS = {
  pt2: '.pt2',
  stp: '.stp',
  pt1: '.pt1',
  pt3: '.pt3',
  stc: '.stc',
  asc: '.asc',
  psm: '.psm',
  psc: '.psc',
  ftc: '.ftc',
  gtr: '.gtr',
  sqt: '.sqt',
  psg: '.psg',
  ayc: '.ayc',
  ay: '.ay',
};

const FORMAT_ORDER = Object.keys(EXTENSIONS);

const FORMAT_IDS = {
  pt2: 0,
  stp: 1,
  pt1: 2,
  pt3: 3,
  stc: 4,
  asc: 5,
  psm: 6,
  psc: 7,
  ftc: 8,
  gtr: 9,
  sqt: 10,
  psg: 11,
  ayc: 12,
  ay: 13,
};

function detectFormat(fileName) {
  const lower = fileName.toLowerCase();
  return FORMAT_ORDER.find((fmt) => lower.endsWith(EXTENSIONS[fmt])) ?? null;
}

function requireExport(module, name) {
  const fn = module[name];
  if (typeof fn !== 'function') {
    throw new Error(`Missing WASM export: ${name}`);
  }
  return fn;
}

function requireHeap(module, name) {
  const heap = module[name];
  if (!heap) {
    throw new Error(`Missing WASM heap: ${name}`);
  }
  return heap;
}

function bindWasm(module) {
  requireHeap(module, 'HEAPU8');
  requireHeap(module, 'HEAPF32');

  return {
    moduleRecord: module,
    _pt2_init: requireExport(module, '_pt2_init'),
    _pt2_load: requireExport(module, '_pt2_load'),
    _pt2_render_all: requireExport(module, '_pt2_render_all'),
    _pt2_get_duration_ms: requireExport(module, '_pt2_get_duration_ms'),
    _pt2_get_total_frames: requireExport(module, '_pt2_get_total_frames'),
    _pt2_reset: requireExport(module, '_pt2_reset'),
    _pt2_free: requireExport(module, '_pt2_free'),
    _pt2_malloc: requireExport(module, '_pt2_malloc'),
    _pt2_mem_free: requireExport(module, '_pt2_mem_free'),
  };
}

function callWasm(fn, errorCode, ...args) {
  try {
    return fn(...args);
  } catch (error) {
    const detail = error instanceof Error ? error.message : String(error);
    throw new Error(`${errorCode}:${detail}`);
  }
}

async function hashChannelData(channelData) {
  const totalBytes = channelData.reduce((sum, ch) => sum + ch.byteLength, 0);
  const merged = new Uint8Array(totalBytes);
  let offset = 0;

  for (const channel of channelData) {
    const bytes = new Uint8Array(channel.buffer, channel.byteOffset, channel.byteLength);
    merged.set(bytes, offset);
    offset += bytes.byteLength;
  }

  const digest = await crypto.subtle.digest('SHA-256', merged);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

class Pt2Core {
  modulePromise = null;
  sampleRate = 44100;
  channels = 2;

  async loadModule() {
    if (!this.modulePromise) {
      this.modulePromise = (async () => {
        let loader;
        try {
          loader = await import(new URL('../wasm/zxtune-core.js?v=20260707g', import.meta.url).href);
        } catch {
          throw new Error('WASM_FETCH_FAILED');
        }

        const createModule = loader.default;
        if (typeof createModule !== 'function') {
          throw new Error('WASM_INIT_FAILED');
        }

        const module = await createModule({});
        return bindWasm(module);
      })().catch((error) => {
        this.modulePromise = null;
        throw error;
      });
    }

    return this.modulePromise;
  }

  async init(sampleRate, channels) {
    const wasm = await this.loadModule();
    this.sampleRate = sampleRate;
    this.channels = channels;

    if (wasm._pt2_init(sampleRate, channels) !== 0) {
      throw new Error('WASM_INIT_FAILED');
    }
  }

  async render(trackId, fileName, data) {
    const format = detectFormat(fileName);
    if (!format) {
      throw new Error('WASM_BAD_EXTENSION');
    }

    const wasm = await this.loadModule();
    const inputSize = data.byteLength;
    const inputPtr = callWasm(wasm._pt2_malloc, 'WASM_RUNTIME_EXCEPTION', inputSize);

    if (inputPtr <= 0) {
      throw new Error('WASM_ALLOC_INPUT_FAILED');
    }

    requireHeap(wasm.moduleRecord, 'HEAPU8').set(new Uint8Array(data), inputPtr);

    let handle = 0;
    let outputPtr = 0;

    try {
      handle = callWasm(wasm._pt2_load, 'WASM_RUNTIME_EXCEPTION', inputPtr, inputSize, FORMAT_IDS[format]);
      if (handle <= 0) {
        throw new Error(`WASM_LOAD_FAILED:${handle}`);
      }

      const totalFrames = callWasm(wasm._pt2_get_total_frames, 'WASM_RUNTIME_EXCEPTION', handle);
      const durationMs = callWasm(wasm._pt2_get_duration_ms, 'WASM_RUNTIME_EXCEPTION', handle);

      if (totalFrames <= 0 || totalFrames > 576_000_000 || durationMs <= 0) {
        throw new Error('WASM_INVALID_METADATA');
      }

      const totalSamples = totalFrames * this.channels;
      const outputBytes = totalSamples * Float32Array.BYTES_PER_ELEMENT;
      outputPtr = callWasm(wasm._pt2_malloc, 'WASM_RUNTIME_EXCEPTION', outputBytes);

      if (outputPtr <= 0) {
        throw new Error('WASM_ALLOC_OUTPUT_FAILED');
      }

      if (callWasm(wasm._pt2_render_all, 'WASM_RUNTIME_EXCEPTION', handle, outputPtr, totalSamples) !== 0) {
        throw new Error('WASM_RENDER_FAILED');
      }

      const heapF32 = requireHeap(wasm.moduleRecord, 'HEAPF32');
      const startIndex = outputPtr / Float32Array.BYTES_PER_ELEMENT;
      const interleaved = heapF32.subarray(startIndex, startIndex + totalSamples);

      const channelData = [];
      for (let ch = 0; ch < this.channels; ch += 1) {
        const channel = new Float32Array(totalFrames);
        for (let frame = 0; frame < totalFrames; frame += 1) {
          channel[frame] = interleaved[frame * this.channels + ch];
        }
        channelData.push(channel);
      }

      const pcmHash = await hashChannelData(channelData);

      return {
        trackId,
        sampleRate: this.sampleRate,
        channels: this.channels,
        totalFrames,
        durationMs,
        channelData,
        pcmHash,
      };
    } finally {
      if (handle > 0) {
        try {
          callWasm(wasm._pt2_reset, 'WASM_RUNTIME_EXCEPTION', handle);
          callWasm(wasm._pt2_free, 'WASM_RUNTIME_EXCEPTION', handle);
        } catch {
          // ignore cleanup errors
        }
      }
      if (outputPtr > 0) {
        try {
          callWasm(wasm._pt2_mem_free, 'WASM_RUNTIME_EXCEPTION', outputPtr);
        } catch {
          // ignore cleanup errors
        }
      }
      try {
        callWasm(wasm._pt2_mem_free, 'WASM_RUNTIME_EXCEPTION', inputPtr);
      } catch {
        // ignore cleanup errors
      }
    }
  }
}

class AyumiCore {
  modulePromise = null;

  async loadModule() {
    if (!this.modulePromise) {
      this.modulePromise = (async () => {
        const loader = await import(new URL('../wasm/ayumi-core.js', import.meta.url).href);
        const createModule = loader.default;
        if (typeof createModule !== 'function') {
          throw new Error('AYUMI_INIT_FAILED');
        }
        const module = await createModule({});
        if (!module._ayw_create || !module._ayw_set_regs || !module._ayw_process) {
          throw new Error('AYUMI_EXPORTS_MISSING');
        }
        return module;
      })().catch((error) => {
        this.modulePromise = null;
        throw error;
      });
    }
    return this.modulePromise;
  }

  async renderFromRegsTrace(trace, sampleRate = 44100, channelMask = [true, true, true]) {
    const module = await this.loadModule();
    const chip = module._ayw_create(0, 1773400, sampleRate);
    if (!chip) {
      throw new Error('AYUMI_CHIP_CREATE_FAILED');
    }

    const frameRate = trace?.frameRate ?? 50;
    const frameCount = trace?.frameCount ?? 0;
    if (!trace?.registers || frameCount <= 0) {
      module._ayw_destroy(chip);
      throw new Error('AYUMI_BAD_TRACE');
    }

    const frameSamples = Math.max(1, Math.floor(sampleRate / frameRate));
    const totalFrames = frameCount * frameSamples;
    const left = new Float32Array(totalFrames);
    const right = new Float32Array(totalFrames);

    const regsPtr = module._malloc(14);
    const lPtr = module._malloc(frameSamples * 4);
    const rPtr = module._malloc(frameSamples * 4);

    if (!regsPtr || !lPtr || !rPtr) {
      module._ayw_destroy(chip);
      if (regsPtr) module._free(regsPtr);
      if (lPtr) module._free(lPtr);
      if (rPtr) module._free(rPtr);
      throw new Error('AYUMI_ALLOC_FAILED');
    }

    try {
      for (let frame = 0; frame < frameCount; frame += 1) {
        const offset = frame * 14;
        const regs = new Uint8Array(trace.registers.subarray(offset, offset + 14));
        applyChannelMaskToRegs(regs, channelMask);
        module.HEAPU8.set(regs, regsPtr);
        module._ayw_set_regs(chip, regsPtr);
        module._ayw_process(chip, lPtr, rPtr, frameSamples);

        const lView = module.HEAPF32.subarray(lPtr / 4, lPtr / 4 + frameSamples);
        const rView = module.HEAPF32.subarray(rPtr / 4, rPtr / 4 + frameSamples);
        left.set(lView, frame * frameSamples);
        right.set(rView, frame * frameSamples);
      }
    } finally {
      module._free(regsPtr);
      module._free(lPtr);
      module._free(rPtr);
      module._ayw_destroy(chip);
    }

    const channelData = [left, right];
    const pcmHash = await hashChannelData(channelData);
    return {
      sampleRate,
      channels: 2,
      totalFrames,
      durationMs: Math.round((totalFrames / sampleRate) * 1000),
      channelData,
      pcmHash,
    };
  }
}

function applyChannelMaskToRegs(regs, channelMask) {
  if (!Array.isArray(channelMask) || channelMask.length < 3) {
    return;
  }
  let mixer = regs[7] ?? 0;
  for (let ch = 0; ch < 3; ch += 1) {
    if (channelMask[ch]) {
      continue;
    }
    regs[10 + ch] = 0;
    mixer |= (1 << ch);
    mixer |= (1 << (ch + 3));
  }
  regs[7] = mixer;
}

class ZxtuneRegsCore {
  modulePromise = null;

  async loadModule() {
    if (!this.modulePromise) {
      this.modulePromise = (async () => {
        const loader = await import(new URL('../wasm/zxtune-regs-core.js', import.meta.url).href);
        const createModule = loader.default;
        if (typeof createModule !== 'function') {
          throw new Error('REGS_INIT_FAILED');
        }
        const module = await createModule({});
        if (!module._zxt_regs_load || !module._zxt_regs_next_frame || !module._zxt_regs_free) {
          throw new Error('REGS_EXPORTS_MISSING');
        }
        return module;
      })().catch((error) => {
        this.modulePromise = null;
        throw error;
      });
    }
    return this.modulePromise;
  }

  async extractTrace(data, durationMs, frameRate = 50) {
    const module = await this.loadModule();
    const frameCount = Math.max(1, Math.ceil((durationMs / 1000) * frameRate));
    const inputPtr = module._malloc(data.byteLength);
    const outPtr = module._malloc(14);
    if (!inputPtr || !outPtr) {
      if (inputPtr) module._free(inputPtr);
      if (outPtr) module._free(outPtr);
      throw new Error('REGS_ALLOC_FAILED');
    }

    let handle = 0;
    try {
      module.HEAPU8.set(new Uint8Array(data), inputPtr);
      handle = module._zxt_regs_load(inputPtr, data.byteLength);
      if (handle <= 0) {
        throw new Error('REGS_LOAD_FAILED');
      }

      const registers = new Uint8Array(frameCount * 14);
      for (let frame = 0; frame < frameCount; frame += 1) {
        const rc = module._zxt_regs_next_frame(handle, outPtr);
        if (rc !== 0) {
          throw new Error('REGS_READ_FAILED');
        }
        registers.set(module.HEAPU8.subarray(outPtr, outPtr + 14), frame * 14);
      }

      return { frameRate, frameCount, registers };
    } finally {
      if (handle > 0) {
        module._zxt_regs_reset(handle);
        module._zxt_regs_free(handle);
      }
      module._free(outPtr);
      module._free(inputPtr);
    }
  }
}

const core = new Pt2Core();
const ayumi = new AyumiCore();
const regsCore = new ZxtuneRegsCore();

function isMostlyText(bytes) {
  if (bytes.length === 0) {
    return false;
  }

  let printable = 0;
  for (let i = 0; i < bytes.length; i += 1) {
    const value = bytes[i];
    if (value === 9 || value === 10 || value === 13 || (value >= 32 && value <= 126)) {
      printable += 1;
    }
  }

  return printable / bytes.length >= 0.95;
}

function isUniform(bytes) {
  if (bytes.length < 2) {
    return true;
  }

  const first = bytes[0];
  for (let i = 1; i < bytes.length; i += 1) {
    if (bytes[i] !== first) {
      return false;
    }
  }

  return true;
}

function isMostlyZero(bytes) {
  if (bytes.length === 0) {
    return true;
  }

  let zeros = 0;
  for (let i = 0; i < bytes.length; i += 1) {
    if (bytes[i] === 0) {
      zeros += 1;
    }
  }

  return zeros / bytes.length >= 0.9;
}

function validateFile(fileName, data) {
  const format = detectFormat(fileName);
  if (!format) {
    return { ok: false, reason: 'BAD_EXTENSION' };
  }

  if (data.byteLength < 64 || data.byteLength > 4_194_304) {
    return { ok: false, reason: 'BAD_SIZE' };
  }

  // AY containers have mostly-text header/signature (ZXAY...), so
  // strict binary heuristics generate false positives for valid files.
  if (format === 'ay') {
    return { ok: true };
  }

  const bytes = new Uint8Array(data);
  const header = bytes.subarray(0, Math.min(128, bytes.length));

  if (isMostlyText(header)) {
    return { ok: false, reason: 'TEXT_LIKE' };
  }

  if (isUniform(header)) {
    return { ok: false, reason: 'UNIFORM_HEADER' };
  }

  if (isMostlyZero(header)) {
    return { ok: false, reason: 'ZERO_HEAVY_HEADER' };
  }

  return { ok: true };
}

let activeRequestId = null;
let activeAbort = null;
let sampleRate = 44100;
let channels = 2;

function post(message, transfer = []) {
  self.postMessage(message, transfer);
}

function postPrepareError(requestId, trackId, code, internalReason) {
  post({
    type: 'PREPARE_ERROR',
    requestId,
    trackId,
    code,
    internalReason,
  });
}

async function withTimeout(promise, timeoutMs) {
  let timer = null;

  const timeout = new Promise((_, reject) => {
    timer = self.setTimeout(() => reject(new Error('TIMEOUT')), timeoutMs);
  });

  try {
    return await Promise.race([promise, timeout]);
  } finally {
    if (timer !== null) {
      self.clearTimeout(timer);
    }
  }
}

function toErrorMessage(error) {
  if (error instanceof Error && error.message) {
    return error.message;
  }
  if (typeof error === 'string' && error) {
    return error;
  }
  if (typeof error === 'number' || typeof error === 'boolean' || typeof error === 'bigint') {
    return String(error);
  }
  try {
    const json = JSON.stringify(error);
    if (json && json !== '{}') {
      return json;
    }
  } catch {
    // ignore json failures
  }
  return String(error ?? 'UNKNOWN');
}

async function prepareTrack(requestId, trackId, fileName, data) {
  const validation = validateFile(fileName, data);
  if (!validation.ok) {
    postPrepareError(requestId, trackId, 'INVALID_FILE', validation.reason);
    return;
  }

  activeRequestId = requestId;
  activeAbort = new AbortController();
  const signal = activeAbort.signal;

  try {
    const prepared = await withTimeout(core.render(trackId, fileName, data), 60_000);

    if (signal.aborted || activeRequestId !== requestId) {
      return;
    }

    const transfer = prepared.channelData.map((channel) => channel.buffer);
    post({ type: 'PREPARE_OK', requestId, prepared }, transfer);
  } catch (error) {
    if (signal.aborted) {
      return;
    }

    const message = toErrorMessage(error);
    const code = message === 'TIMEOUT'
      ? 'TIMEOUT'
      : message.startsWith('WASM_')
        ? 'WASM_FAILURE'
        : 'UNSUPPORTED';

    postPrepareError(requestId, trackId, code, message);
  } finally {
    if (activeRequestId === requestId) {
      activeRequestId = null;
      activeAbort = null;
    }
  }
}

async function renderMaskedTrack(requestId, trackId, ayRegsTrace, channelMask) {
  activeRequestId = requestId;
  activeAbort = new AbortController();
  const signal = activeAbort.signal;

  try {
    const prepared = await withTimeout(
      ayumi.renderFromRegsTrace(ayRegsTrace, sampleRate, channelMask),
      15_000,
    );

    if (signal.aborted || activeRequestId !== requestId) {
      return;
    }

    const transfer = prepared.channelData.map((channel) => channel.buffer);
    post({
      type: 'PREPARE_OK',
      requestId,
      prepared: {
        ...prepared,
        trackId,
      },
    }, transfer);
  } catch (error) {
    if (signal.aborted) {
      return;
    }
    const message = toErrorMessage(error);
    postPrepareError(requestId, trackId, 'WASM_FAILURE', message);
  } finally {
    if (activeRequestId === requestId) {
      activeRequestId = null;
      activeAbort = null;
    }
  }
}

self.onmessage = async (event) => {
  const message = event.data;

  if (message.type === 'INIT') {
    try {
      sampleRate = message.sampleRate;
      channels = message.channels;
      await core.init(sampleRate, channels);
      post({ type: 'INIT_OK' });
    } catch (error) {
      post({
        type: 'INIT_ERROR',
        internalReason: toErrorMessage(error) || 'INIT_FAILED',
      });
    }
    return;
  }

  if (message.type === 'CANCEL_REQUEST' && activeRequestId === message.requestId) {
    activeAbort?.abort();
    activeRequestId = null;
    activeAbort = null;
    return;
  }

  if (message.type === 'PREPARE_TRACK') {
    await prepareTrack(message.requestId, message.trackId, message.fileName, message.data);
    return;
  }

  if (message.type === 'RENDER_MASKED') {
    await renderMaskedTrack(
      message.requestId,
      message.trackId,
      message.ayRegsTrace,
      message.channelMask,
    );
  }
};
