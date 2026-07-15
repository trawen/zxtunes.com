import { AudioPlayer } from './audio-player.js';
import { RenderService } from './render-service.js';

const SUPPORTED_FORMATS = [
  '.pt2', '.stp', '.pt1', '.pt3', '.stc', '.asc',
  '.psm', '.psc', '.ftc', '.gtr', '.sqt', '.psg', '.ayc', '.ay',
];

const decoder = new TextDecoder('cp866');

const elements = {
  fileInput: document.getElementById('file-input'),
  dropZone: document.getElementById('drop-zone'),
  trackTitle: document.getElementById('track-title'),
  trackMeta: document.getElementById('track-meta'),
  status: document.getElementById('status'),
  playBtn: document.getElementById('play-btn'),
  pauseBtn: document.getElementById('pause-btn'),
  stopBtn: document.getElementById('stop-btn'),
  progress: document.getElementById('progress'),
  currentTime: document.getElementById('current-time'),
  duration: document.getElementById('duration'),
  playlist: document.getElementById('playlist'),
};

const PLAYLIST_MANIFEST_URL = './top_music/manifest.json';

if (location.protocol === 'file:') {
  throw new Error('Open the player via http://localhost:5173 (run: npm run dev)');
}

const renderService = new RenderService(new URL('./pt2-worker.js?v=20260707g', import.meta.url));
const audioPlayer = new AudioPlayer({
  onEnded: () => {
    setStatus('ready', 'Готово');
    updateControls('ready');
    syncProgress();
  },
});

let state = 'idle';
let prepared = null;
let progressTimer = null;
let currentTrack = null;
let playlistItems = [];

function setStatus(kind, text) {
  elements.status.dataset.kind = kind;
  elements.status.textContent = text;
}

function formatTime(ms) {
  const totalSec = Math.floor(ms / 1000);
  const min = Math.floor(totalSec / 60);
  const sec = totalSec % 60;
  return `${min}:${sec.toString().padStart(2, '0')}`;
}

function updateControls(nextState) {
  state = nextState;
  const hasTrack = Boolean(prepared);

  elements.playBtn.disabled = !hasTrack || nextState === 'playing' || nextState === 'loading';
  elements.pauseBtn.disabled = nextState !== 'playing';
  elements.stopBtn.disabled = !hasTrack || nextState === 'idle' || nextState === 'loading';
  elements.progress.disabled = !hasTrack || nextState === 'loading';
}

function syncProgress() {
  const snapshot = audioPlayer.getSnapshot();
  const durationMs = prepared?.durationMs ?? snapshot.durationMs;

  elements.currentTime.textContent = formatTime(snapshot.currentTimeMs);
  elements.duration.textContent = formatTime(durationMs);
  elements.progress.value = durationMs > 0
    ? Math.round((snapshot.currentTimeMs / durationMs) * 1000)
    : 0;
  elements.progress.max = 1000;
}

function startProgressTimer() {
  stopProgressTimer();
  progressTimer = window.setInterval(syncProgress, 200);
}

function stopProgressTimer() {
  if (progressTimer !== null) {
    clearInterval(progressTimer);
    progressTimer = null;
  }
}

function trimCp866(bytes) {
  const end = bytes.indexOf(0);
  const slice = end >= 0 ? bytes.subarray(0, end) : bytes;
  return decoder.decode(slice).trim();
}

function parseTitleAuthorFromName(fileName) {
  const base = fileName.replace(/\.[^.]+$/, '');
  const slashParts = base.split('/').map((part) => part.trim()).filter(Boolean);

  if (slashParts.length > 1) {
    return {
      title: slashParts[0],
      author: slashParts.slice(1).join(' / '),
    };
  }

  const dashMatch = base.match(/^(.+?)\s*-\s*(.+)$/);
  if (dashMatch) {
    return {
      title: dashMatch[1].trim(),
      author: dashMatch[2].trim(),
    };
  }

  return { title: base, author: null };
}

function parsePt2Metadata(data) {
  if (data.byteLength < 131) {
    return { title: null, author: null };
  }

  const bytes = new Uint8Array(data, 101, 30);
  const title = trimCp866(bytes);
  return parseTitleAuthorFromName(title || '');
}

function parseStpMetadata(data) {
  const marker = 'KSA SOFTWARE COMPILATION OF ';
  if (data.byteLength < 63) {
    return { title: null, author: null };
  }

  const header = trimCp866(new Uint8Array(data, 10, 28));
  if (header !== marker) {
    return { title: null, author: null };
  }

  const title = trimCp866(new Uint8Array(data, 38, 25));
  return parseTitleAuthorFromName(title || '');
}

function detectFormat(fileName) {
  const lower = fileName.toLowerCase();
  return SUPPORTED_FORMATS.find((ext) => lower.endsWith(ext))?.slice(1) ?? null;
}

function readMetadata(fileName, data) {
  const format = detectFormat(fileName);
  if (format === 'pt2') {
    return parsePt2Metadata(data);
  }
  if (format === 'stp') {
    return parseStpMetadata(data);
  }

  return parseTitleAuthorFromName(fileName);
}

function renderTrackInfo(track) {
  elements.trackTitle.textContent = track.title || track.fileName;
  const metaParts = [
    track.author,
    track.format?.toUpperCase(),
    track.size ? `${Math.round(track.size / 1024)} KB` : null,
  ].filter(Boolean);

  elements.trackMeta.textContent = metaParts.join(' · ');
  updatePlaylistActiveState();
}

function updatePlaylistActiveState() {
  for (const button of elements.playlist.querySelectorAll('.playlist__item')) {
    button.classList.toggle('is-active', button.dataset.fileName === currentTrack?.fileName);
  }
}

function setPlaylistLoading(fileName, loading) {
  for (const button of elements.playlist.querySelectorAll('.playlist__item')) {
    button.disabled = loading && button.dataset.fileName !== fileName;
  }
}

async function loadTrack(fileName, data, size, { autoPlay = false } = {}) {
  const format = detectFormat(fileName);
  if (!format) {
    setStatus('error', `Неподдерживаемый формат. Нужен один из: ${SUPPORTED_FORMATS.join(', ')}`);
    return false;
  }

  updateControls('loading');
  setStatus('loading', autoPlay ? 'Загрузка и воспроизведение...' : 'Рендер трека...');
  setPlaylistLoading(fileName, true);
  audioPlayer.stopAndReset();
  audioPlayer.setAyRegsTrace(null);
  prepared = null;
  currentTrack = null;
  syncProgress();

  try {
    const metadata = readMetadata(fileName, data);
    const trackId = crypto.randomUUID();

    currentTrack = {
      id: trackId,
      fileName,
      title: metadata.title,
      author: metadata.author,
      format,
      size,
    };

    renderTrackInfo(currentTrack);

    const rendered = await renderService.prepareTrack(trackId, fileName, data);
    await audioPlayer.ensureContext();
    audioPlayer.createAudioBuffer(rendered);
    audioPlayer.setAyRegsTrace(null);
    prepared = rendered;

    if (autoPlay) {
      await playCurrent(0);
    } else {
      setStatus('ready', 'Готово к воспроизведению');
      updateControls('ready');
      syncProgress();
    }

    return true;
  } catch (error) {
    console.error(error);
    const internalReason = error instanceof Error ? error.message : 'UNKNOWN';
    const message = internalReason === 'PREPARE_CANCELLED'
      ? 'Загрузка отменена'
      : `Не удалось воспроизвести файл (${internalReason})`;

    setStatus('error', message);
    updateControls('idle');
    return false;
  } finally {
    setPlaylistLoading(null, false);
  }
}

async function loadFile(file) {
  const data = await file.arrayBuffer();
  await loadTrack(file.name, data, file.size);
}

async function loadPlaylistTrack(fileName) {
  const url = `./top_music/${encodeURIComponent(fileName)}`;
  const response = await fetch(url, { cache: 'no-cache' });

  if (!response.ok) {
    setStatus('error', `Файл не найден: ${fileName}`);
    return;
  }

  const data = await response.arrayBuffer();
  await loadTrack(fileName, data, data.byteLength, { autoPlay: true });
}

function renderPlaylist() {
  elements.playlist.replaceChildren();

  for (const item of playlistItems) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'playlist__item';
    button.dataset.fileName = item.fileName;

    const name = document.createElement('span');
    name.className = 'playlist__name';
    name.textContent = item.title || item.fileName;

    const sub = document.createElement('span');
    sub.className = 'playlist__sub';
    sub.textContent = [item.author, item.format?.toUpperCase()].filter(Boolean).join(' · ');

    button.append(name, sub);
    button.addEventListener('click', () => {
      void loadPlaylistTrack(item.fileName);
    });

    elements.playlist.append(button);
  }
}

async function loadPlaylist() {
  try {
    const response = await fetch(PLAYLIST_MANIFEST_URL, { cache: 'no-cache' });
    if (!response.ok) {
      return;
    }

    const manifest = await response.json();
    if (!manifest?.files?.length) {
      return;
    }

    playlistItems = await Promise.all(manifest.files.map(async (fileName) => {
      const url = `./top_music/${encodeURIComponent(fileName)}`;
      const format = detectFormat(fileName);
      let title = null;
      let author = null;

      if (format === 'pt2' || format === 'stp') {
        try {
          const metaResponse = await fetch(url, { cache: 'no-cache' });
          if (metaResponse.ok) {
            const data = await metaResponse.arrayBuffer();
            const metadata = readMetadata(fileName, data);
            title = metadata.title;
            author = metadata.author;
          }
        } catch {
          // ignore metadata errors
        }
      }

      if (!title) {
        const parsed = parseTitleAuthorFromName(fileName);
        title = parsed.title;
        author = parsed.author;
      }

      return { fileName, title, author, format };
    }));

    renderPlaylist();
  } catch (error) {
    console.error('playlist_load_failed', error);
  }
}

async function playCurrent(offsetMs) {
  if (!prepared) {
    return;
  }

  await audioPlayer.ensureContext();

  const startMs = typeof offsetMs === 'number'
    ? offsetMs
    : audioPlayer.getSnapshot().currentTimeMs;

  audioPlayer.playFromOffset(startMs);
  setStatus('playing', 'Воспроизведение');
  updateControls('playing');
  startProgressTimer();
  syncProgress();
}

function pauseCurrent() {
  audioPlayer.pause();
  setStatus('paused', 'Пауза');
  updateControls('paused');
  stopProgressTimer();
  syncProgress();
}

function stopCurrent() {
  audioPlayer.stopAndReset();
  setStatus('ready', 'Остановлено');
  updateControls('ready');
  stopProgressTimer();
  syncProgress();
}

function seekTo(ratio) {
  if (!prepared) {
    return;
  }

  const targetMs = prepared.durationMs * ratio;
  audioPlayer.seek(targetMs);

  if (state === 'playing') {
    void playCurrent();
  } else {
    syncProgress();
  }
}

elements.fileInput.addEventListener('change', (event) => {
  const file = event.target.files?.[0];
  if (file) {
    void loadFile(file);
  }
});

elements.playBtn.addEventListener('click', () => {
  void playCurrent();
});

elements.pauseBtn.addEventListener('click', pauseCurrent);
elements.stopBtn.addEventListener('click', stopCurrent);

elements.progress.addEventListener('input', (event) => {
  const ratio = Number(event.target.value) / 1000;
  seekTo(ratio);
});

['dragenter', 'dragover'].forEach((eventName) => {
  elements.dropZone.addEventListener(eventName, (event) => {
    event.preventDefault();
    elements.dropZone.classList.add('dragover');
  });
});

['dragleave', 'drop'].forEach((eventName) => {
  elements.dropZone.addEventListener(eventName, (event) => {
    event.preventDefault();
    elements.dropZone.classList.remove('dragover');
  });
});

elements.dropZone.addEventListener('drop', (event) => {
  const file = event.dataTransfer?.files?.[0];
  if (file) {
    void loadFile(file);
  }
});

elements.dropZone.addEventListener('click', () => {
  elements.fileInput.click();
});

document.addEventListener('keydown', (event) => {
  if (event.target instanceof HTMLInputElement) {
    return;
  }

  if (event.code === 'Space') {
    event.preventDefault();
    if (state === 'playing') {
      pauseCurrent();
    } else if (prepared) {
      void playCurrent();
    }
  }
});

updateControls('idle');
setStatus('idle', 'Загрузите AY-трек');
syncProgress();

void renderService.init().catch((error) => {
  console.error(error);
  setStatus('error', 'Не удалось инициализировать WASM');
});

void loadPlaylist();
