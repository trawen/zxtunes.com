export class AudioPlayer {
  constructor({ onEnded } = {}) {
    this.onEnded = onEnded ?? (() => {});
    this.audioContext = null;
    this.analyserNode = null;
    this.sourceNode = null;
    this.scriptNode = null;
    this.scriptInputNode = null;
    this.currentBuffer = null;
    this.ayRegsTrace = null;
    this.mode = 'buffer';
    this.startedAtContextTimeSec = 0;
    this.offsetSec = 0;

    this.ayumiModulePromise = null;
    this.ayumiModule = null;
    this.ayumiChip = 0;
    this.ayumiRegsPtr = 0;
    this.ayumiLeftPtr = 0;
    this.ayumiRightPtr = 0;
    this.ayumiTempSize = 0;

    this.ayFrameRate = 50;
    this.aySamplesPerFrame = 0;
    this.ayFrameCount = 0;
    this.ayDurationSamples = 0;
    this.aySampleCursor = 0;
    this.ayLastAppliedFrame = -1;
    this.ayEndedNotified = false;
  }

  async ensureContext() {
    const AudioCtx = window.AudioContext || window.webkitAudioContext;
    if (!AudioCtx) {
      throw new Error('AUDIO_CONTEXT_UNSUPPORTED');
    }

    if (!this.audioContext) {
      this.audioContext = new AudioCtx();
      this.analyserNode = this.audioContext.createAnalyser();
      this.analyserNode.fftSize = 2048;
      this.analyserNode.smoothingTimeConstant = 0.5;
      this.analyserNode.connect(this.audioContext.destination);
    }

    if (this.audioContext.state === 'suspended') {
      await this.audioContext.resume();
    }

    return this.audioContext;
  }

  /**
   * Must run inside a user-gesture handler (tap/click).
   * iOS Safari only unlocks Web Audio if resume + a real start() happen in that gesture.
   */
  unlockFromGesture() {
    const AudioCtx = window.AudioContext || window.webkitAudioContext;
    if (!AudioCtx) {
      return Promise.reject(new Error('AUDIO_CONTEXT_UNSUPPORTED'));
    }

    if (!this.audioContext) {
      this.audioContext = new AudioCtx();
      this.analyserNode = this.audioContext.createAnalyser();
      this.analyserNode.fftSize = 2048;
      this.analyserNode.smoothingTimeConstant = 0.5;
      this.analyserNode.connect(this.audioContext.destination);
    }

    const ctx = this.audioContext;
    try {
      const silent = ctx.createBuffer(1, 1, ctx.sampleRate || 44100);
      const source = ctx.createBufferSource();
      source.buffer = silent;
      source.connect(this.analyserNode ?? ctx.destination);
      source.start(0);
    } catch {
      // ignore — resume alone is enough on some browsers
    }

    if (ctx.state === 'suspended') {
      return ctx.resume().then(() => ctx);
    }

    return Promise.resolve(ctx);
  }

  getAnalyser() {
    return this.analyserNode;
  }

  setAyRegsTrace(trace) {
    this.ayRegsTrace = trace ?? null;
    if (this.ayRegsTrace) {
      this.mode = 'ay';
      return;
    }
    this.mode = 'buffer';
  }

  createAudioBuffer(prepared) {
    const context = this.audioContext;
    if (!context) {
      throw new Error('AudioContext is not initialized');
    }

    const buffer = context.createBuffer(
      prepared.channels,
      prepared.totalFrames,
      prepared.sampleRate,
    );

    prepared.channelData.forEach((channel, index) => {
      buffer.copyToChannel(channel, index);
    });

    this.currentBuffer = buffer;
    this.ayRegsTrace = null;
    this.mode = 'buffer';
    this.offsetSec = 0;
    return buffer;
  }

  playFromOffset(offsetMs = 0) {
    if (!this.audioContext) {
      return Promise.resolve();
    }

    if (this.mode === 'ay' && this.ayRegsTrace) {
      return this.playAyRealtime(offsetMs);
    }

    if (!this.currentBuffer) {
      return Promise.resolve();
    }

    if (this.audioContext.state === 'suspended') {
      void this.audioContext.resume();
    }

    this.stopSourceNode();

    const durationMs = this.currentBuffer.duration * 1000;
    const offsetSec = clamp(offsetMs, 0, durationMs) / 1000;
    const source = this.audioContext.createBufferSource();

    source.buffer = this.currentBuffer;
    source.connect(this.analyserNode ?? this.audioContext.destination);
    source.onended = () => {
      if (!this.sourceNode || this.sourceNode !== source) {
        return;
      }

      this.sourceNode = null;
      this.offsetSec = 0;
      this.onEnded();
    };

    this.startedAtContextTimeSec = this.audioContext.currentTime;
    this.offsetSec = offsetSec;
    source.start(0, offsetSec);
    this.sourceNode = source;
    return Promise.resolve();
  }

  pause() {
    if (!this.audioContext) {
      return;
    }

    if (this.scriptNode) {
      const elapsed = this.audioContext.currentTime - this.startedAtContextTimeSec;
      this.offsetSec += Math.max(0, elapsed);
      this.stopScriptNode();
      return;
    }

    if (!this.sourceNode) {
      return;
    }

    const elapsed = this.audioContext.currentTime - this.startedAtContextTimeSec;
    this.offsetSec += Math.max(0, elapsed);
    this.stopSourceNode();
  }

  stopAndReset() {
    this.stopSourceNode();
    this.stopScriptNode();
    this.offsetSec = 0;
  }

  seek(offsetMs) {
    if (this.mode === 'ay' && this.ayRegsTrace) {
      const frameRate = this.ayRegsTrace.frameRate || 50;
      const durationMs = ((this.ayRegsTrace.frameCount || 0) / frameRate) * 1000;
      this.offsetSec = clamp(offsetMs, 0, durationMs) / 1000;
      return;
    }

    if (!this.currentBuffer) {
      return;
    }

    const durationMs = this.currentBuffer.duration * 1000;
    this.offsetSec = clamp(offsetMs, 0, durationMs) / 1000;
  }

  getSnapshot() {
    if (!this.audioContext) {
      return { currentTimeMs: 0, durationMs: 0 };
    }

    if (this.mode === 'ay' && this.ayRegsTrace) {
      const frameRate = this.ayRegsTrace.frameRate || 50;
      const durationMs = this.ayDurationSamples > 0
        ? (this.ayDurationSamples / this.audioContext.sampleRate) * 1000
        : ((this.ayRegsTrace.frameCount || 0) / frameRate) * 1000;
      const elapsed = this.scriptNode
        ? Math.max(0, this.audioContext.currentTime - this.startedAtContextTimeSec)
        : 0;
      return {
        currentTimeMs: clamp((this.offsetSec + elapsed) * 1000, 0, durationMs || Number.MAX_SAFE_INTEGER),
        durationMs,
      };
    }

    if (!this.currentBuffer) {
      return { currentTimeMs: 0, durationMs: 0 };
    }

    const durationMs = this.currentBuffer.duration * 1000;
    const elapsed = this.sourceNode
      ? Math.max(0, this.audioContext.currentTime - this.startedAtContextTimeSec)
      : 0;

    return {
      currentTimeMs: clamp((this.offsetSec + elapsed) * 1000, 0, durationMs),
      durationMs,
    };
  }

  stopSourceNode() {
    if (!this.sourceNode) {
      return;
    }

    this.sourceNode.onended = null;
    this.sourceNode.stop();
    this.sourceNode.disconnect();
    this.sourceNode = null;
  }

  stopScriptNode() {
    if (this.scriptInputNode) {
      try {
        this.scriptInputNode.onended = null;
        this.scriptInputNode.stop();
      } catch {
        // already stopped
      }
      try {
        this.scriptInputNode.disconnect();
      } catch {
        // already disconnected
      }
      this.scriptInputNode = null;
    }

    if (!this.scriptNode) {
      return;
    }
    this.scriptNode.onaudioprocess = null;
    this.scriptNode.disconnect();
    this.scriptNode = null;
  }

  async loadAyumiModule() {
    if (!this.ayumiModulePromise) {
      this.ayumiModulePromise = (async () => {
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
        this.ayumiModulePromise = null;
        throw error;
      });
    }
    this.ayumiModule = await this.ayumiModulePromise;
    return this.ayumiModule;
  }

  async prepareAyumiState() {
    const module = await this.loadAyumiModule();
    if (this.ayumiChip) {
      module._ayw_destroy(this.ayumiChip);
      this.ayumiChip = 0;
    }
    if (this.ayumiRegsPtr) {
      module._free(this.ayumiRegsPtr);
      this.ayumiRegsPtr = 0;
    }
    if (this.ayumiLeftPtr) {
      module._free(this.ayumiLeftPtr);
      this.ayumiLeftPtr = 0;
    }
    if (this.ayumiRightPtr) {
      module._free(this.ayumiRightPtr);
      this.ayumiRightPtr = 0;
    }

    this.ayumiChip = module._ayw_create(0, 1773400, this.audioContext.sampleRate);
    if (!this.ayumiChip) {
      throw new Error('AYUMI_CHIP_CREATE_FAILED');
    }
    this.ayumiRegsPtr = module._malloc(14);
    this.ayumiTempSize = 2048;
    this.ayumiLeftPtr = module._malloc(this.ayumiTempSize * 4);
    this.ayumiRightPtr = module._malloc(this.ayumiTempSize * 4);
    if (!this.ayumiRegsPtr || !this.ayumiLeftPtr || !this.ayumiRightPtr) {
      throw new Error('AYUMI_ALLOC_FAILED');
    }
  }

  async playAyRealtime(offsetMs) {
    if (!this.ayRegsTrace || !this.audioContext) {
      return;
    }
    if (this.audioContext.state === 'suspended') {
      await this.audioContext.resume();
    }

    this.stopSourceNode();
    this.stopScriptNode();

    this.ayFrameRate = this.ayRegsTrace.frameRate ?? 50;
    this.ayFrameCount = this.ayRegsTrace.frameCount ?? 0;
    this.aySamplesPerFrame = this.audioContext.sampleRate / this.ayFrameRate;
    this.ayDurationSamples = Math.max(1, Math.round(this.ayFrameCount * this.aySamplesPerFrame));
    this.ayEndedNotified = false;

    await this.prepareAyumiState();

    const targetOffsetSec = clamp(offsetMs, 0, (this.ayDurationSamples / this.audioContext.sampleRate) * 1000) / 1000;
    this.offsetSec = targetOffsetSec;
    this.aySampleCursor = 0;
    this.ayLastAppliedFrame = -1;
    await this.fastForwardAyTo(Math.floor(targetOffsetSec * this.audioContext.sampleRate));

    // Safari/WebKit: ScriptProcessor with 0 inputs never fires onaudioprocess.
    // Keep a looping silent buffer connected as input so the callback runs.
    const processorSize = 2048;
    const scriptNode = this.audioContext.createScriptProcessor(processorSize, 1, 2);
    scriptNode.onaudioprocess = (event) => {
      this.fillAyOutput(event.outputBuffer);
    };

    const silentBuffer = this.audioContext.createBuffer(1, processorSize, this.audioContext.sampleRate);
    const silentSource = this.audioContext.createBufferSource();
    silentSource.buffer = silentBuffer;
    silentSource.loop = true;
    silentSource.connect(scriptNode);
    scriptNode.connect(this.analyserNode ?? this.audioContext.destination);
    silentSource.start(0);

    this.scriptInputNode = silentSource;
    this.scriptNode = scriptNode;
    this.startedAtContextTimeSec = this.audioContext.currentTime;
  }

  async fastForwardAyTo(targetSample) {
    const module = this.ayumiModule;
    if (!module || targetSample <= 0) {
      return;
    }
    const chunk = Math.min(this.ayumiTempSize, 2048);
    while (this.aySampleCursor < targetSample) {
      const run = Math.min(chunk, targetSample - this.aySampleCursor);
      this.processAySamples(run);
      this.aySampleCursor += run;
    }
  }

  fillAyOutput(outputBuffer) {
    const left = outputBuffer.getChannelData(0);
    const right = outputBuffer.getChannelData(1);
    left.fill(0);
    right.fill(0);

    if (!this.ayRegsTrace || this.aySampleCursor >= this.ayDurationSamples) {
      this.notifyAyEnded();
      return;
    }

    let written = 0;
    while (written < left.length && this.aySampleCursor < this.ayDurationSamples) {
      const frameIndex = Math.min(
        this.ayFrameCount - 1,
        Math.floor(this.aySampleCursor / this.aySamplesPerFrame),
      );
      const frameEndSample = Math.min(
        this.ayDurationSamples,
        Math.ceil((frameIndex + 1) * this.aySamplesPerFrame),
      );
      const run = Math.min(left.length - written, frameEndSample - this.aySampleCursor);
      this.processAySamples(run, left, right, written);
      written += run;
      this.aySampleCursor += run;
    }

    if (this.aySampleCursor >= this.ayDurationSamples) {
      this.notifyAyEnded();
    }
  }

  processAySamples(sampleCount, outLeft = null, outRight = null, outOffset = 0) {
    if (sampleCount <= 0 || !this.ayumiModule || !this.ayRegsTrace) {
      return;
    }
    const frameIndex = Math.min(
      this.ayFrameCount - 1,
      Math.floor(this.aySampleCursor / this.aySamplesPerFrame),
    );
    if (frameIndex !== this.ayLastAppliedFrame) {
      const regsOffset = frameIndex * 14;
      const regs = this.ayRegsTrace.registers.subarray(regsOffset, regsOffset + 14);
      this.ayumiModule.HEAPU8.set(regs, this.ayumiRegsPtr);
      this.ayumiModule._ayw_set_regs(this.ayumiChip, this.ayumiRegsPtr);
      this.ayLastAppliedFrame = frameIndex;
    }
    this.ayumiModule._ayw_process(this.ayumiChip, this.ayumiLeftPtr, this.ayumiRightPtr, sampleCount);
    if (!outLeft || !outRight) {
      return;
    }
    const lView = this.ayumiModule.HEAPF32.subarray(
      this.ayumiLeftPtr / 4,
      this.ayumiLeftPtr / 4 + sampleCount,
    );
    const rView = this.ayumiModule.HEAPF32.subarray(
      this.ayumiRightPtr / 4,
      this.ayumiRightPtr / 4 + sampleCount,
    );
    outLeft.set(lView, outOffset);
    outRight.set(rView, outOffset);
  }

  notifyAyEnded() {
    if (this.ayEndedNotified) {
      return;
    }
    this.ayEndedNotified = true;
    this.stopScriptNode();
    this.offsetSec = 0;
    this.onEnded();
  }
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(value, max));
}
