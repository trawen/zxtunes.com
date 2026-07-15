import { AudioPlayer } from './audio-player.js?v=6';
import { RenderService } from './render-service.js?v=6';

function isMobilePlayback() {
	if (typeof navigator === 'undefined') {
		return false;
	}
	if (/iPhone|iPad|iPod|Android/i.test(navigator.userAgent || '')) {
		return true;
	}
	return navigator.maxTouchPoints > 1 && /Mac/i.test(navigator.platform || '');
}

const mobilePlayback = isMobilePlayback();
const renderService = new RenderService(new URL('./pt2-worker.js?v=20260715d', import.meta.url), {
	sampleRate: mobilePlayback ? 22050 : 44100,
	channels: 2,
});
const audioPlayer = new AudioPlayer({
	onEnded() {
		playing = false;
		updatePlayButton(true);
		stopProgressTimer();
		if (repeat && prepared) {
			audioPlayer.seek(0);
			void playCurrent(0);
			return;
		}
		if (!repeat) {
			NextTrack();
		}
	},
});

var pl = [];
var cm = [];
var id_comment = 0;
var start_time = 0;
var last_track = 0;
var id_thanks = 0;
var tht = ['Thank you!', 'Speccy rulez!', 'Spectrum alive!', '8-bit never die!'];

var song;
var prepared = null;
var playing = false;
var repeat = false;
var shuffle = false;
var timeElapsed = false;
var shuffleOrder = [];
var shufflePos = 0;
var tracksById = {};
var autoplayUnlockBound = false;
var pendingAutoplayId = 0;
var autoplay = 0;
var author_id = 0;
var author_name = '';
var first_track = 0;
var zxtunesPlaylist = [];
var zxtuneBooted = false;
var progressTimer = null;
var engineReady = false;
var engineInitPromise = null;

function formatTime(seconds) {
	seconds = Math.max(0, Math.floor(seconds));
	var min = Math.floor(seconds / 60);
	var sec = seconds % 60;
	return min + ':' + (sec < 10 ? '0' : '') + sec;
}

function parseDisplayTime(str) {
	var parts = String(str || '0:00').split(':');
	var min = parseInt(parts[0], 10) || 0;
	var sec = parseInt(parts[1], 10) || 0;
	return min * 60 + sec;
}

function createSong(trackMeta) {
	var fallbackSec = parseDisplayTime(trackMeta.time);
	return {
		getProgress() {
			var snap = audioPlayer.getSnapshot();
			var durationMs = prepared?.durationMs ?? snap.durationMs;
			if (durationMs > 0) {
				return Math.min(1, Math.max(0, snap.currentTimeMs / durationMs));
			}
			return 0;
		},
		setProgress(k) {
			if (!prepared) {
				return;
			}
			if (k < 0) {
				k = 0;
			}
			if (k > 0.98) {
				k = 0.98;
			}
			audioPlayer.seek(prepared.durationMs * k);
		},
		getTime() {
			var snap = audioPlayer.getSnapshot();
			var durationMs = prepared?.durationMs ?? snap.durationMs;
			if (durationMs > 0) {
				return formatTime((durationMs - snap.currentTimeMs) / 1000);
			}
			if (fallbackSec > 0) {
				return formatTime(fallbackSec * (1 - this.getProgress()));
			}
			return '0:00';
		},
		getTimeElapsed() {
			var snap = audioPlayer.getSnapshot();
			if (snap.durationMs > 0 || prepared) {
				return formatTime(snap.currentTimeMs / 1000);
			}
			if (fallbackSec > 0) {
				return formatTime(fallbackSec * this.getProgress());
			}
			return '0:00';
		},
	};
}

function ensureEngineReady() {
	if (engineReady) {
		return Promise.resolve();
	}
	if (!engineInitPromise) {
		engineInitPromise = renderService.init().then(function () {
			engineReady = true;
		});
	}
	return engineInitPromise;
}

function startProgressTimer() {
	stopProgressTimer();
	progressTimer = window.setInterval(updateProgress, 200);
}

function stopProgressTimer() {
	if (progressTimer !== null) {
		clearInterval(progressTimer);
		progressTimer = null;
	}
}

function buildTrackIndex() {
	tracksById = {};
	if (typeof zxtunesPlaylist === 'undefined') {
		return;
	}
	for (var i = 0; i < zxtunesPlaylist.length; i++) {
		tracksById[zxtunesPlaylist[i].id] = zxtunesPlaylist[i];
	}
	shuffleOrder = [];
	for (var j = 0; j < zxtunesPlaylist.length; j++) {
		shuffleOrder[j] = j;
	}
	shuffleArray(shuffleOrder);
}

function shuffleArray(a) {
	var j, x, i;
	for (i = a.length - 1; i > 0; i--) {
		j = Math.floor(Math.random() * (i + 1));
		x = a[i];
		a[i] = a[j];
		a[j] = x;
	}
}

function getTrack(trackId) {
	return tracksById[trackId] || null;
}

function showPlayerBar() {
	var bar = document.getElementById('zx_ay_player_wrap');
	if (bar) {
		bar.className = 'zx-ay-player-wrap zx-ay-visible';
		document.body.className = (document.body.className + ' zx-ay-playing').replace(/\s+/g, ' ').trim();
	}
}

function updatePlayButton(paused) {
	var button = document.getElementById('b_play');
	if (!button) {
		return;
	}
	button.className = paused ? 'b_control b_play' : 'b_control b_pause';
}

function setRowState(trackId, isPlaying) {
	var btn = document.getElementById('m' + trackId);
	if (!btn) {
		return;
	}
	if (isPlaying) {
		btn.className = 'stop';
		pl[trackId] = 1;
	} else {
		btn.className = 'play';
		pl[trackId] = 0;
	}
}

function highlightTrack(trackId) {
	var rows = document.querySelectorAll('.zx-track-row');
	for (var i = 0; i < rows.length; i++) {
		rows[i].classList.remove('zx-ay-track-active');
	}
	var row = document.getElementById('s' + trackId);
	if (row) {
		row.classList.add('zx-ay-track-active');
	}
}

function updateProgress() {
	if (!song) {
		return;
	}
	var progress = song.getProgress();
	var left = document.getElementById('track_progress_left');
	var right = document.getElementById('track_progress_right');
	if (left && right) {
		var k = Math.round(progress * 10000) * 0.01;
		left.style.width = k + '%';
		right.style.width = (100 - k) + '%';
	}
	var time = timeElapsed ? song.getTimeElapsed() : song.getTime();
	var trackTime = document.getElementById('track_time');
	if (trackTime) {
		trackTime.textContent = time;
	}
}

function decodeEntities(text) {
	if (!text) {
		return '';
	}
	var ta = document.createElement('textarea');
	ta.innerHTML = text;
	return ta.value;
}

function updateTrackMarquee() {
	var name = document.getElementById('track_name');
	if (!name) {
		return;
	}
	var wrap = name.parentNode;
	if (!wrap || !wrap.classList || !wrap.classList.contains('track_name_wrap')) {
		return;
	}
	name.classList.remove('track_name--scroll');
	name.style.removeProperty('--marquee-shift');
	name.style.display = 'inline-block';
	name.style.maxWidth = 'none';
	name.style.width = 'max-content';
	name.style.overflow = 'visible';
	var overflow = name.scrollWidth - wrap.clientWidth;
	name.style.removeProperty('display');
	name.style.removeProperty('max-width');
	name.style.removeProperty('width');
	name.style.removeProperty('overflow');
	if (overflow > 4) {
		name.style.setProperty('--marquee-shift', '-' + overflow + 'px');
		name.classList.add('track_name--scroll');
	}
}

function updateTexts(track) {
	var name = document.getElementById('track_name');
	if (!name) {
		return;
	}
	var title = track.title ? decodeEntities(track.title) : '';
	var label = decodeEntities(author_name) + ' – ' + decodeEntities(track.filename);
	if (title) {
		label += ' – ' + title;
	}
	name.textContent = label;
	document.title = label + ' : ZXTunes';
	updateTrackMarquee();
}

async function startPlayback(buffer, track) {
	renderService.cancelActiveRequest();
	audioPlayer.stopAndReset();
	var rendered = await renderService.prepareTrack(String(track.id), track.filename, buffer.slice(0));
	await audioPlayer.ensureContext();
	audioPlayer.createAudioBuffer(rendered);
	prepared = rendered;
	song = createSong(track);
	updateTexts(track);
	updateProgress();
}

function pausePlayback() {
	audioPlayer.pause();
	playing = false;
	updatePlayButton(true);
	stopProgressTimer();
}

function stopEngine() {
	renderService.cancelActiveRequest();
	audioPlayer.stopAndReset();
	prepared = null;
	song = null;
	playing = false;
	updatePlayButton(true);
	stopProgressTimer();
}

function recordPlayStat(prevTrack) {
	if (!prevTrack || !pl[prevTrack]) {
		return;
	}
	var now = new Date();
	if (now - start_time <= 5000) {
		return;
	}
	var aid = document.getElementById('a' + prevTrack);
	var authorId = aid ? aid.textContent : author_id;
	var downloads = document.getElementById('dw' + prevTrack);
	if (downloads) {
		downloads.textContent = parseInt(downloads.textContent || '0', 10) + 1;
	}
	if (typeof $ !== 'undefined') {
		$.post('/playing_up.php', { id: prevTrack, id_author: authorId, type: 2 });
	}
}

function updatePlayUrl(trackId) {
	if (typeof author_id === 'undefined' || !author_id || !trackId) {
		return;
	}
	try {
		var url = new URL(window.location.href);
		url.searchParams.set('id', String(author_id));
		url.searchParams.set('play', String(trackId));
		if (!url.searchParams.get('md')) {
			url.searchParams.set('md', '1');
		}
		var next = url.pathname + url.search + url.hash;
		var current = window.location.pathname + window.location.search + window.location.hash;
		if (next !== current) {
			history.replaceState({ play: trackId }, '', next);
		}
	} catch (e) {}
}

function getAutoplayTrackId() {
	var id = parseInt(autoplay, 10);
	if (id > 0) {
		return id;
	}
	try {
		id = parseInt(new URLSearchParams(window.location.search).get('play'), 10);
		return id > 0 ? id : 0;
	} catch (e) {
		return 0;
	}
}

function unlockAudioForGesture() {
	return audioPlayer.unlockFromGesture().catch(function () {
		return null;
	});
}

function markPlaybackStarted(trackId) {
	playing = true;
	updatePlayButton(false);
	if (trackId) {
		setRowState(trackId, true);
	}
	pendingAutoplayId = 0;
	startProgressTimer();
}

function markPlaybackWaiting(trackId) {
	playing = false;
	updatePlayButton(true);
	if (trackId) {
		setRowState(trackId, false);
	}
	pendingAutoplayId = trackId;
	stopProgressTimer();
}

function bindAutoplayUnlock(retryFn) {
	if (autoplayUnlockBound) {
		return;
	}
	autoplayUnlockBound = true;
	var unlock = function () {
		document.removeEventListener('pointerdown', unlock, true);
		document.removeEventListener('touchend', unlock, true);
		document.removeEventListener('keydown', unlock, true);
		autoplayUnlockBound = false;
		void unlockAudioForGesture().then(function () {
			retryFn();
		});
	};
	document.addEventListener('pointerdown', unlock, true);
	document.addEventListener('touchend', unlock, true);
	document.addEventListener('keydown', unlock, true);
}

async function ensureAudioRunning(done, onBlocked) {
	try {
		await audioPlayer.ensureContext();
		if (audioPlayer.audioContext && audioPlayer.audioContext.state === 'running') {
			await done();
			return;
		}
		if (onBlocked) {
			onBlocked();
		}
		bindAutoplayUnlock(done);
	} catch (e) {
		if (onBlocked) {
			onBlocked();
		}
		bindAutoplayUnlock(done);
	}
}

function beginTrackLoad(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		return;
	}

	var onBlocked = function () {
		markPlaybackWaiting(trackId);
	};

	if (resumeOnly && prepared && song) {
		void ensureAudioRunning(async function () {
			await playCurrent();
			markPlaybackStarted(trackId);
		}, onBlocked);
		return;
	}

	var req = new XMLHttpRequest();
	req.open('GET', track.url, true);
	req.responseType = 'arraybuffer';
	req.onload = function () {
		if (!req.response) {
			alert('Sorry, track not found. :(');
			stopEngine();
			setRowState(trackId, false);
			return;
		}
		void (async function () {
			try {
				await startPlayback(req.response, track);
				await audioPlayer.ensureContext();
				if (!audioPlayer.audioContext || audioPlayer.audioContext.state !== 'running') {
					onBlocked();
					bindAutoplayUnlock(async function () {
						await playCurrent(0);
						markPlaybackStarted(trackId);
					});
					return;
				}
				await playCurrent(0);
				markPlaybackStarted(trackId);
			} catch (e) {
				console.error('zxtune playback failed', e);
				alert('Sorry, this track cannot be played in the browser.');
				stopEngine();
				setRowState(trackId, false);
			}
		})();
	};
	req.onerror = function () {
		alert('Sorry, track not found. :(');
		stopEngine();
		setRowState(trackId, false);
	};
	req.send(null);
}

async function playCurrent(offsetMs) {
	if (!prepared) {
		return;
	}
	await audioPlayer.ensureContext();
	if (audioPlayer.audioContext && audioPlayer.audioContext.state === 'suspended') {
		await audioPlayer.audioContext.resume();
	}
	var startMs = typeof offsetMs === 'number'
		? offsetMs
		: audioPlayer.getSnapshot().currentTimeMs;
	await audioPlayer.playFromOffset(startMs);
	playing = true;
	updatePlayButton(false);
	startProgressTimer();
	updateProgress();
}

function loadAndPlay(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		alert('Sorry, track not found.');
		return;
	}

	void ensureEngineReady().then(function () {
		if (!resumeOnly && last_track && last_track != trackId) {
			recordPlayStat(last_track);
			setRowState(last_track, false);
		}

		showPlayerBar();
		last_track = trackId;
		updatePlayUrl(trackId);
		if (!resumeOnly) {
			start_time = new Date();
		}
		highlightTrack(trackId);

		if (resumeOnly && prepared && song) {
			void ensureAudioRunning(async function () {
				await playCurrent();
				markPlaybackStarted(trackId);
			}, function () {
				markPlaybackWaiting(trackId);
			});
			return;
		}

		if (!resumeOnly) {
			stopEngine();
		}

		beginTrackLoad(trackId, resumeOnly);
	});
}

function PlayB(trackId) {
	trackId = parseInt(trackId, 10);
	if (trackId == last_track && playing) {
		pausePlayback();
		setRowState(trackId, false);
		return;
	}
	void unlockAudioForGesture();
	if (trackId == last_track && prepared && !playing) {
		loadAndPlay(trackId, true);
		return;
	}
	loadAndPlay(trackId, false);
}

function togglePlay() {
	if (playing) {
		pausePlayback();
		if (last_track) {
			setRowState(last_track, false);
		}
	} else {
		void unlockAudioForGesture();
		if (last_track && prepared) {
			loadAndPlay(last_track, true);
		} else if (pendingAutoplayId || last_track) {
			PlayB(pendingAutoplayId || last_track);
		} else if (first_track) {
			PlayB(first_track);
		}
	}
}

function PlayFull() {
	togglePlay();
}

function PlayPause() {
	togglePlay();
}

function NextTrack() {
	var track = getTrack(last_track);
	if (!track) {
		return;
	}
	var nextId;
	if (shuffle) {
		shufflePos = (shufflePos + 1) % shuffleOrder.length;
		nextId = zxtunesPlaylist[shuffleOrder[shufflePos]].id;
	} else {
		nextId = parseInt(track.next_id, 10);
	}
	if (nextId) {
		PlayB(nextId);
	}
}

function PreviousTrack() {
	var track = getTrack(last_track);
	if (!track) {
		return;
	}
	var prevId;
	if (shuffle) {
		shufflePos = shufflePos - 1;
		if (shufflePos < 0) {
			shufflePos = shuffleOrder.length - 1;
		}
		prevId = zxtunesPlaylist[shuffleOrder[shufflePos]].id;
	} else {
		prevId = parseInt(track.prev_id, 10);
	}
	if (prevId) {
		PlayB(prevId);
	}
}

function playShuffle() {
	var button = document.getElementById('b_shuffle');
	shuffle = !shuffle;
	if (button) {
		button.style.opacity = shuffle ? '1' : '0.4';
	}
}

function playRepeat() {
	var button = document.getElementById('b_repeat');
	repeat = !repeat;
	if (button) {
		button.style.opacity = repeat ? '1' : '0.4';
	}
}

function toggleTime() {
	timeElapsed = !timeElapsed;
	updateProgress();
}

function changeProgress(event) {
	if (!song || !prepared) {
		return;
	}
	var rect = event.currentTarget.getBoundingClientRect();
	var x = event.pageX - rect.left;
	var k = x / rect.width;
	if (k < 0) {
		k = 0;
	}
	if (k > 0.98) {
		k = 0.98;
	}
	song.setProgress(k);
	if (playing) {
		void playCurrent();
	} else {
		updateProgress();
	}
}

function ShowDetails(nm, ev) {
	if (typeof $ === 'undefined') {
		return;
	}
	if (ev == 'on') {
		var pos = $('#s' + nm).position();
		$('#test' + nm).html("<div id='songinfo' style='z-index: 5; position: absolute;'><img src='images/songinfo.png' border=0></div>");
		$('#songinfo').css('top', pos.top - 25);
		$('#songinfo').css('left', pos.left + $('#s' + nm).width() + 8);
	} else {
		$('#test' + nm).html('');
	}
}

function Rate(id) {
	if (typeof $ === 'undefined' || !$('#r' + id).hasClass('rating')) {
		return;
	}
	id_thanks = id;
	$('#r' + id).removeClass('rating').addClass('r_off');
	var rating = parseInt($('#rn' + id).text() || '0', 10) + 1;
	$('#rn' + id).text(rating);
	var aid = $('#a' + id).text();
	$.post('/playing_up.php', { type: 'test-request', id: id, id_author: aid, type: 1 }, OpenThanks);
}

function Comm(id) {
	if (typeof $ === 'undefined') {
		return;
	}
	if (cm[id]) {
		$('#c' + id).hide();
		cm[id] = 0;
	} else {
		$('#c' + id).show();
		cm[id] = 1;
		id_comment = id;
		$.post('/get_comments.php', { type: 'test-request', id: id }, InsertComment);
	}
}

function InsertComment(data) {
	$('#c' + id_comment).html(data);
}

function OpenThanks() {
	if (typeof $ === 'undefined') {
		return;
	}
	var pos = $('#r' + id_thanks).position();
	$('#thanks1').css({ top: pos.top - 40, left: pos.left - 16 });
	$('#thanks2').text(tht[Math.floor(Math.random() * tht.length)]);
	$('#thanks1').fadeIn(1, function () {
		setTimeout(function () { $('#thanks1').fadeOut(500); }, 2000);
	});
}

function AddComment(id) {
	if (typeof $ === 'undefined') {
		return;
	}
	var nick = $('#nick' + id).val();
	var email = $('#email' + id).val();
	var mess = $('#mess' + id).val();
	if (!nick) {
		alert('Enter <Nick>');
		return;
	}
	if (!mess) {
		alert('Enter <Message>');
		return;
	}
	var aid = $('#a' + id).text();
	$.post('/get_comments.php', { type: 'test-request', id: id, nick: nick, email: email, mess: mess, id_author: aid }, InsertComment);
	var comments = parseInt($('#cm' + id).text() || '0', 10) + 1;
	$('#cm' + id).text(comments);
}

function readPlayerConfig() {
	var el = document.getElementById('zxtunes-player-config');
	if (!el) {
		return;
	}
	try {
		var cfg = JSON.parse(el.textContent);
		if (cfg.autoplay !== undefined) {
			autoplay = cfg.autoplay;
		}
		if (cfg.author_id !== undefined) {
			author_id = cfg.author_id;
		}
		if (cfg.author_name !== undefined) {
			author_name = cfg.author_name;
		}
		if (cfg.first_track !== undefined) {
			first_track = cfg.first_track;
		}
		if (cfg.playlist) {
			zxtunesPlaylist = cfg.playlist;
		}
	} catch (e) {
		zxtunesPlaylist = [];
	}
}

function bootAyPlayer() {
	if (zxtuneBooted) {
		return;
	}
	zxtuneBooted = true;
	readPlayerConfig();
	buildTrackIndex();
	if (window.addEventListener) {
		window.addEventListener('resize', updateTrackMarquee);
		document.addEventListener('touchstart', unlockAudioForGesture, { capture: true, passive: true });
		document.addEventListener('pointerdown', unlockAudioForGesture, { capture: true });
	}
	void ensureEngineReady().then(function () {
		var trackId = getAutoplayTrackId();
		if (trackId > 0) {
			PlayB(trackId);
		} else {
			updateTrackMarquee();
		}
	}).catch(function (e) {
		console.error('zxtune init failed', e);
	});
}

function initAyPlayer() {
	bootAyPlayer();
}

window.PlayB = PlayB;
window.togglePlay = togglePlay;
window.PlayFull = PlayFull;
window.PlayPause = PlayPause;
window.NextTrack = NextTrack;
window.PreviousTrack = PreviousTrack;
window.playShuffle = playShuffle;
window.playRepeat = playRepeat;
window.toggleTime = toggleTime;
window.changeProgress = changeProgress;
window.ShowDetails = ShowDetails;
window.Rate = Rate;
window.Comm = Comm;
window.AddComment = AddComment;

if (typeof $ !== 'undefined') {
	$(document).ready(initAyPlayer);
} else if (document.addEventListener) {
	document.addEventListener('DOMContentLoaded', initAyPlayer);
}
