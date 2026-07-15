import { VIBE_FRAGMENT_SHADER, VIBE_VERTEX_SHADER } from './vibe-shaders.js';

const FPS = 25;
const AUDIO_GAIN = 3.2;
const AUDIO_REACT_MIX = 0.45;

function sampleAyTrace() {
  return { note: 0, dynamics: 0 };
}

function hslToRgb(h, s, l) {
  const hue = ((h % 360) + 360) % 360;
  const chroma = (1 - Math.abs(2 * l - 1)) * s;
  const x = chroma * (1 - Math.abs(((hue / 30) % 2) - 1));
  let r = 0;
  let g = 0;
  let b = 0;

  if (hue < 60) [r, g, b] = [chroma, x, 0];
  else if (hue < 120) [r, g, b] = [x, chroma, 0];
  else if (hue < 180) [r, g, b] = [0, chroma, x];
  else if (hue < 240) [r, g, b] = [0, x, chroma];
  else if (hue < 300) [r, g, b] = [x, 0, chroma];
  else [r, g, b] = [chroma, 0, x];

  const m = l - chroma / 2;
  return [r + m, g + m, b + m];
}

function smoothValue(current, target, rise = 0.22, fall = 0.05) {
  if (target > current) {
    return Math.min(1, current + rise);
  }
  return Math.max(0, current - fall);
}

function colorsFromHue(hue, collectionHue = 190) {
  const wrap = (value) => ((value % 360) + 360) % 360;
  const noteHue = wrap(hue);
  const accentHue = wrap(hue + 60);
  const baseHue = wrap(collectionHue);

  return [
    hslToRgb(baseHue, 1, 0.5),
    hslToRgb(accentHue, 1, 0.5),
    hslToRgb(noteHue, 1, 0.5),
    hslToRgb(wrap(baseHue + 35), 1, 0.5),
    hslToRgb(wrap(accentHue + 35), 1, 0.5),
    hslToRgb(wrap(noteHue + 35), 1, 0.5),
  ];
}

class SmoothScalar {
  constructor(initial = 0, durationMs = 1000) {
    this.current = initial;
    this.target = initial;
    this.durationMs = durationMs;
  }

  set(value) {
    this.target = value;
  }

  step(deltaMs) {
    const step = deltaMs / this.durationMs;
    if (this.target > this.current) {
      this.current = Math.min(this.target, this.current + step);
    } else {
      this.current = Math.max(this.target, this.current - step);
    }
    return this.current;
  }
}

class ColorChannel {
  constructor(hue) {
    const [r, g, b] = hslToRgb(hue, 1, 0.5);
    this.r = new SmoothScalar(r, 900);
    this.g = new SmoothScalar(g, 900);
    this.b = new SmoothScalar(b, 900);
  }

  setHue(hue, saturation = 1, lightness = 0.5) {
    const [r, g, b] = hslToRgb(hue, saturation, lightness);
    this.r.set(r);
    this.g.set(g);
    this.b.set(b);
  }

  step(deltaMs) {
    return [this.r.step(deltaMs), this.g.step(deltaMs), this.b.step(deltaMs)];
  }
}

function createPalette(collectionHue = 190) {
  const wrap = (value) => ((value % 360) + 360) % 360;
  const channels = [
    new ColorChannel(wrap(collectionHue)),
    new ColorChannel(300),
    new ColorChannel(50),
    new ColorChannel(wrap(collectionHue + 35)),
    new ColorChannel(320),
    new ColorChannel(50),
  ];

  return {
    channels,
    update(deltaMs) {
      return channels.map((channel) => channel.step(deltaMs));
    },
  };
}

export class VibeVisualizer {
  constructor(canvas, { hue = 190, collectionHue = hue } = {}) {
    this.canvas = canvas;
    this.collectionHue = collectionHue;
    this.palette = createPalette(collectionHue);
    this.enabled = false;
    this.playing = false;
    this.time = Math.random() * 3600;
    this.energy = new SmoothScalar(0.2, 1000);
    this.audioRatio = new SmoothScalar(0, 1000);
    this.audio = [0, 0, 0];
    this.react = [0, 0, 0];
    this.background = [0, 0, 0];
    this.colors = colorsFromHue(hue, collectionHue);
    this.noteLevel = 0;
    this.noteDynamics = 0;
    this.noteHue = hue;
    this.timeEnergy = 0.2;
    this.prevSpectrumEnergy = 0;
    this.rafId = 0;
    this.frequencyData = null;
    this.waveformData = null;
    this.chipTrace = null;
    this.chipChannel = 0;
    this.getPlaybackTimeMs = null;
    this.rotation = [
      [-0.3, 0.3, 0.2],
      [-0.3, -0.3, -0.2],
      [-0.3, -0.3, 0.2],
    ];
    this.lastFrameMs = 0;

    this.initGl();
  }

  initGl() {
    const gl = this.canvas.getContext('webgl', {
      alpha: false,
      antialias: false,
      preserveDrawingBuffer: false,
    });

    if (!gl) {
      throw new Error('WebGL is not available');
    }

    this.gl = gl;
    this.program = this.createProgram(VIBE_VERTEX_SHADER, VIBE_FRAGMENT_SHADER);
    this.buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, this.buffer);
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]),
      gl.STATIC_DRAW,
    );

    this.attribs = {
      aPosition: gl.getAttribLocation(this.program, 'aPosition'),
    };

    this.uniforms = {
      vScreenSize: gl.getUniformLocation(this.program, 'vScreenSize'),
      vTime: gl.getUniformLocation(this.program, 'vTime'),
      vScale: gl.getUniformLocation(this.program, 'vScale'),
      vColorBackground: gl.getUniformLocation(this.program, 'vColorBackground'),
      vColor: gl.getUniformLocation(this.program, 'vColor'),
      vRotation: gl.getUniformLocation(this.program, 'vRotation'),
      vAudio: gl.getUniformLocation(this.program, 'vAudio'),
      vReact: gl.getUniformLocation(this.program, 'vReact'),
      vSparkDrive: gl.getUniformLocation(this.program, 'vSparkDrive'),
      vInteractionPoint: gl.getUniformLocation(this.program, 'vInteractionPoint'),
      vInteraction: gl.getUniformLocation(this.program, 'vInteraction'),
    };

    this.resize();
  }

  createProgram(vertexSource, fragmentSource) {
    const gl = this.gl;
    const vertexShader = this.compileShader(gl.VERTEX_SHADER, vertexSource);
    const fragmentShader = this.compileShader(gl.FRAGMENT_SHADER, fragmentSource);
    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      throw new Error(gl.getProgramInfoLog(program) || 'Program link failed');
    }

    return program;
  }

  compileShader(type, source) {
    const gl = this.gl;
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);

    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      throw new Error(gl.getShaderInfoLog(shader) || 'Shader compile failed');
    }

    return shader;
  }

  resize() {
    const rect = this.canvas.getBoundingClientRect();
    const dpr = Math.min(window.devicePixelRatio || 1, 2);
    const width = Math.max(1, Math.round(rect.width * dpr));
    const height = Math.max(1, Math.round(rect.height * dpr));

    if (this.canvas.width !== width || this.canvas.height !== height) {
      this.canvas.width = width;
      this.canvas.height = height;
      this.gl.viewport(0, 0, width, height);
    }

    this.screenSize = [width, height];
    this.scale = Math.min(width, height) < 520 ? 0.4 : 0.35;
  }

  setPlaying(isPlaying) {
    this.playing = isPlaying;
    this.audioRatio.set(isPlaying ? 1 : 0);
  }

  setAnalyser(analyser) {
    this.analyser = analyser;
    this.frequencyData = analyser
      ? new Uint8Array(analyser.frequencyBinCount)
      : null;
    this.waveformData = analyser
      ? new Uint8Array(analyser.fftSize)
      : null;
  }

  setChipTrace(trace, channelIndex = 0) {
    this.chipTrace = trace;
    this.chipChannel = channelIndex;
  }

  setChipChannel(channelIndex) {
    this.chipChannel = channelIndex;
  }

  setPlaybackTimeProvider(provider) {
    this.getPlaybackTimeMs = provider;
  }

  updateChipUniforms() {
    const sample = sampleAyTrace(this.chipTrace, this.chipChannel, this.getPlaybackTimeMs());
    const note = sample.note;
    const dynamics = sample.dynamics;

    this.noteLevel = smoothValue(this.noteLevel, note, 0.28, 0.06);
    this.noteDynamics = smoothValue(this.noteDynamics, dynamics, 0.35, 0.08);

    if (note > 0.02) {
      this.noteHue = smoothValue(this.noteHue / 360, (45 + note * 285) / 360, 0.18, 0.04) * 360;
      this.timeEnergy = smoothValue(this.timeEnergy, 0.2 + note * 0.65 + dynamics * 1.4, 0.2, 0.05);
    } else {
      this.timeEnergy = smoothValue(this.timeEnergy, 0.12, 0.02, 0.04);
    }

    const level = this.noteLevel;
    this.background = [0, 0, 0];
    this.audio = [
      Math.min(1.2, level * AUDIO_GAIN),
      Math.min(1.2, level * 0.85 * AUDIO_GAIN),
      Math.min(1.2, level * 0.65 * AUDIO_GAIN),
    ];
    this.react = this.audio.map((value) => value * AUDIO_REACT_MIX + this.noteDynamics * 0.5);
    this.colors = colorsFromHue(this.noteHue, this.collectionHue);
    this.energy.set(this.timeEnergy);
  }

  updatePcmUniforms() {
    if (!this.analyser || !this.frequencyData) {
      this.audio = this.audio.map((value) => smoothValue(value, 0, 0.02, 0.04));
      this.react = this.react.map((value) => smoothValue(value, 0, 0.02, 0.04));
      this.background = [0, 0, 0];
      this.prevSpectrumEnergy = 0;
      return;
    }

    this.analyser.getByteFrequencyData(this.frequencyData);
    const bins = this.frequencyData;
    const third = Math.floor(bins.length / 3) || 1;

    const average = (from, to) => {
      let sum = 0;
      let peak = 0;
      for (let i = from; i < to; i += 1) {
        const value = (bins[i] || 0) / 255;
        sum += value;
        peak = Math.max(peak, value);
      }
      const avg = sum / (to - from);
      const mixed = avg * 0.35 + peak * 0.65;
      return Math.min(1.2, Math.pow(mixed, 0.75) * AUDIO_GAIN);
    };

    const targets = [
      average(0, third),
      average(third, third * 2),
      average(third * 2, bins.length),
    ];

    this.audio = this.audio.map((value, index) => smoothValue(value, targets[index]));
    this.react = this.audio.map((value) => value * AUDIO_REACT_MIX);

    const energy = targets.reduce((sum, value) => sum + value, 0) / targets.length;
    const flux = Math.abs(energy - this.prevSpectrumEnergy);
    this.prevSpectrumEnergy = energy;
    this.background = [0, 0, 0];
    this.energy.set(0.2 + energy * 0.35);
  }

  updateUniforms() {
    if (!this.playing) {
      this.audio = this.audio.map((value) => smoothValue(value, 0, 0.02, 0.04));
      this.react = this.react.map((value) => smoothValue(value, 0, 0.02, 0.04));
      this.noteLevel = smoothValue(this.noteLevel, 0, 0.02, 0.05);
      this.noteDynamics = smoothValue(this.noteDynamics, 0, 0.02, 0.05);
      this.background = [0, 0, 0];
      this.energy.set(0.12);
      return;
    }

    if (this.chipTrace && this.getPlaybackTimeMs) {
      this.updateChipUniforms();
      return;
    }

    this.updatePcmUniforms();
  }

  start() {
    if (this.enabled) {
      return;
    }

    this.enabled = true;
    this.lastFrameMs = performance.now();
    const tick = (now) => {
      if (!this.enabled) {
        return;
      }

      this.rafId = requestAnimationFrame(tick);
      const deltaMs = now - this.lastFrameMs;
      if (deltaMs < (1000 / FPS) - 1) {
        return;
      }

      this.lastFrameMs = now - (deltaMs % (1000 / FPS));
      this.render(deltaMs);
    };

    this.rafId = requestAnimationFrame(tick);
  }

  stop() {
    this.enabled = false;
    cancelAnimationFrame(this.rafId);
  }

  render(deltaMs) {
    this.resize();
    this.updateUniforms();
    this.energy.step(deltaMs);
    this.audioRatio.step(deltaMs);

    this.time = (this.time + (this.energy.current * deltaMs) / 1000) % 86400;

    const ratio = this.audioRatio.current;
    const audio = this.audio.map((value) => value * ratio);
    const react = this.react.map((value) => value * ratio);
    const colors = this.chipTrace
      ? this.colors
      : this.palette.update(deltaMs);

    const gl = this.gl;
    gl.useProgram(this.program);
    gl.bindBuffer(gl.ARRAY_BUFFER, this.buffer);
    gl.enableVertexAttribArray(this.attribs.aPosition);
    gl.vertexAttribPointer(this.attribs.aPosition, 2, gl.FLOAT, false, 0, 0);

    gl.uniform2fv(this.uniforms.vScreenSize, this.screenSize);
    gl.uniform1f(this.uniforms.vTime, this.time);
    gl.uniform1f(this.uniforms.vScale, this.scale);
    gl.uniform3fv(this.uniforms.vColorBackground, this.background);

    for (let i = 0; i < 6; i += 1) {
      gl.uniform3fv(gl.getUniformLocation(this.program, `vColor[${i}]`), colors[i]);
    }

    for (let i = 0; i < 3; i += 1) {
      gl.uniform3fv(gl.getUniformLocation(this.program, `vRotation[${i}]`), this.rotation[i]);
    }

    gl.uniform3fv(this.uniforms.vAudio, audio);
    gl.uniform3fv(this.uniforms.vReact, react);
    gl.uniform1f(this.uniforms.vSparkDrive, 0);
    gl.uniform2f(this.uniforms.vInteractionPoint, 0, 0);
    gl.uniform1f(this.uniforms.vInteraction, 0);

    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  }

  destroy() {
    this.stop();
    const gl = this.gl;
    if (gl && this.buffer) {
      gl.deleteBuffer(this.buffer);
    }
  }
}
