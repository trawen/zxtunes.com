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
var trackLoadInProgress = false;
var loadingTrackId = 0;
var moduleLoaded = false;

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

function getPlayer() {
	try {
		if (window.player) {
			return window.player;
		}
	} catch (e) {}
	return null;
}

function safePlayerCall(fn, fallback) {
	try {
		var p = getPlayer();
		if (!p || !moduleLoaded) {
			return fallback;
		}
		return fn(p);
	} catch (e) {
		return fallback;
	}
}

function createSong(trackMeta) {
	var fallbackSec = parseDisplayTime(trackMeta.time);
	return {
		getProgress() {
			return safePlayerCall(function (p) {
				var max = p.getMaxPlaybackPosition();
				if (max > 0) {
					return Math.min(1, Math.max(0, p.getPlaybackPosition() / max));
				}
				if (fallbackSec > 0) {
					return Math.min(1, p.getCurrentPlaytime() / fallbackSec);
				}
				return 0;
			}, 0);
		},
		setProgress(k) {
			safePlayerCall(function (p) {
				if (k < 0) {
					k = 0;
				}
				if (k > 0.98) {
					k = 0.98;
				}
				var max = p.getMaxPlaybackPosition();
				if (max > 0) {
					p.seekPlaybackPosition(Math.round(max * k));
					return;
				}
				if (fallbackSec > 0) {
					p.seekPlaybackPosition(Math.round(k * fallbackSec * 1000));
				}
			}, null);
		},
		getTime() {
			return safePlayerCall(function (p) {
				var max = p.getMaxPlaybackPosition();
				if (max > 0) {
					var leftMs = Math.max(0, max - p.getPlaybackPosition());
					return formatTime(leftMs / 1000);
				}
				if (fallbackSec > 0) {
					var progress = 0;
					try {
						progress = Math.min(1, p.getCurrentPlaytime() / fallbackSec);
					} catch (e) {}
					return formatTime(fallbackSec * (1 - progress));
				}
				return '0:00';
			}, formatTime(fallbackSec));
		},
		getTimeElapsed() {
			return safePlayerCall(function (p) {
				var max = p.getMaxPlaybackPosition();
				if (max > 0) {
					return formatTime(p.getPlaybackPosition() / 1000);
				}
				return formatTime(p.getCurrentPlaytime());
			}, '0:00');
		},
	};
}

function onWothkeTrackEnd() {
	playing = false;
	updatePlayButton(true);
	stopProgressTimer();
	if (last_track) {
		setRowState(last_track, false);
	}
	if (repeat && last_track) {
		var p = getPlayer();
		if (p) {
			try {
				p.seekPlaybackPosition(0);
			} catch (e) {}
			void unlockAudioForGesture().then(function () {
				try {
					p.play();
				} catch (e2) {}
				markPlaybackStarted(last_track);
			});
		}
		return;
	}
	if (!repeat) {
		NextTrack();
	}
}

function onWothkeTrackReady() {
	moduleLoaded = true;
	var p = getPlayer();
	if (p) {
		try {
			p.play();
		} catch (e) {
			console.error('zxtune play failed', e);
			moduleLoaded = false;
			return;
		}
	}
	if (loadingTrackId) {
		markPlaybackStarted(loadingTrackId);
	}
}

function patchZxTuneBackendAdapter() {
	if (typeof ZxTuneBackendAdapter === 'undefined' || ZxTuneBackendAdapter.prototype.__zxtunesPatched) {
		return;
	}
	var proto = ZxTuneBackendAdapter.prototype;
	proto.__zxtunesPatched = true;
	// Replace existing MEMFS entries so a previous failed load cannot poison reloads.
	var origRegister = proto.registerFileData;
	proto.registerFileData = function (pathFilenameArray, data) {
		var path = pathFilenameArray[0] || '/';
		var name = pathFilenameArray[1];
		var full = (path.slice(-1) === '/' ? path : path + '/') + name;
		try {
			this.Module.FS_unlink(full);
		} catch (eUnlink) {}
		return origRegister.call(this, pathFilenameArray, data);
	};
}

function ensureEngineReady() {
	if (engineReady) {
		var readyPlayer = getPlayer();
		if (readyPlayer && (typeof readyPlayer.isReady !== 'function' || readyPlayer.isReady())) {
			return Promise.resolve();
		}
		engineReady = false;
	}
	if (!engineInitPromise) {
		engineInitPromise = new Promise(function (resolve, reject) {
			var settled = false;
			function finishOk() {
				if (settled) {
					return;
				}
				settled = true;
				engineReady = true;
				resolve();
			}
			function finishFail(err) {
				if (settled) {
					return;
				}
				settled = true;
				engineInitPromise = null;
				engineReady = false;
				reject(err);
			}
			function boot() {
				if (typeof ScriptNodePlayer === 'undefined' || typeof ZxTuneBackendAdapter === 'undefined') {
					finishFail(new Error('WOTHKE_LIBS_MISSING'));
					return;
				}
				try {
					patchZxTuneBackendAdapter();
					// createInstance safely replaces any previous window.player.
					ScriptNodePlayer.createInstance(
						new ZxTuneBackendAdapter(),
						'',
						[],
						false,
						finishOk,
						onWothkeTrackReady,
						onWothkeTrackEnd,
					);
					// Empty preload usually calls onPlayerReady sync; keep a short
					// fallback if adapter readiness is deferred.
					if (!settled) {
						var tries = 0;
						var timer = window.setInterval(function () {
							tries += 1;
							var p = getPlayer();
							if (p && typeof p.isReady === 'function' && p.isReady()) {
								clearInterval(timer);
								finishOk();
							} else if (tries > 400) {
								clearInterval(timer);
								finishFail(new Error('PLAYER_INIT_TIMEOUT'));
							}
						}, 50);
					}
				} catch (e) {
					finishFail(e);
				}
			}
			if (typeof ScriptNodePlayer !== 'undefined' && typeof ZxTuneBackendAdapter !== 'undefined') {
				boot();
				return;
			}
			var tries = 0;
			var timer = window.setInterval(function () {
				tries += 1;
				if (typeof ScriptNodePlayer !== 'undefined' && typeof ZxTuneBackendAdapter !== 'undefined') {
					clearInterval(timer);
					boot();
				} else if (tries > 400) {
					clearInterval(timer);
					finishFail(new Error('WOTHKE_LIBS_TIMEOUT'));
				}
			}, 50);
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

function updateProgressFallback(track) {
	var left = document.getElementById('track_progress_left');
	var right = document.getElementById('track_progress_right');
	if (left && right) {
		left.style.width = '0%';
		right.style.width = '100%';
	}
	var trackTime = document.getElementById('track_time');
	if (trackTime) {
		trackTime.textContent = track && track.time ? track.time : '0:00';
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

function unlockAudioForGesture() {
	try {
		if (typeof setGlobalWebAudioCtx === 'function') {
			setGlobalWebAudioCtx();
		}
		var ctx = window._gPlayerAudioCtx;
		if (!ctx) {
			return Promise.resolve();
		}
		try {
			var beep = ctx.createBuffer(1, 1, ctx.sampleRate || 44100);
			var src = ctx.createBufferSource();
			src.buffer = beep;
			src.connect(ctx.destination);
			src.start(0);
		} catch (eBeep) {}
		if (ctx.state === 'suspended') {
			return ctx.resume().catch(function () {
				return null;
			});
		}
	} catch (e) {}
	return Promise.resolve();
}

function pausePlayback() {
	var p = getPlayer();
	if (p) {
		try {
			p.pause();
		} catch (e) {}
	}
	playing = false;
	updatePlayButton(true);
	stopProgressTimer();
}

function stopEngine() {
	stopProgressTimer();
	moduleLoaded = false;
	var p = getPlayer();
	if (p) {
		try {
			p.pause();
		} catch (e) {}
	}
	prepared = null;
	song = null;
	playing = false;
	loadingTrackId = 0;
	updatePlayButton(true);
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

function safeTuneFilename(track) {
	var fn = String(track.filename || '').trim();
	if (!fn) {
		fn = 'track' + track.id + '.pt3';
	}
	fn = fn.replace(/[\\/]+/g, '_').replace(/[?#*<>:"|]/g, '_').replace(/\s+/g, '_');
	if (fn.indexOf('.') < 0) {
		fn += '.pt3';
	}
	return track.id + '_' + fn;
}

function isLikelyBinaryTune(buffer) {
	if (!buffer || buffer.byteLength < 16) {
		return false;
	}
	var head = new Uint8Array(buffer, 0, Math.min(64, buffer.byteLength));
	var text = String.fromCharCode.apply(null, head.slice(0, 6)).toLowerCase();
	return text !== '<html>' && text !== '<!doc';
}

function fetchTrackBuffer(track) {
	return new Promise(function (resolve, reject) {
		var req = new XMLHttpRequest();
		req.open('GET', track.url, true);
		req.responseType = 'arraybuffer';
		req.onload = function () {
			if (!isLikelyBinaryTune(req.response)) {
				reject(new Error('TRACK_NOT_FOUND'));
				return;
			}
			resolve(req.response);
		};
		req.onerror = function () {
			reject(new Error('TRACK_XHR_FAILED'));
		};
		req.send(null);
	});
}

function startLoadedTrack(trackId, cacheName, buffer, track) {
	var player = getPlayer();
	if (!player || typeof player.prepareTrackForPlayback !== 'function') {
		throw new Error('PLAYER_NOT_READY');
	}
	loadingTrackId = trackId;

	// Prefer prepareTrackForPlayback: loadMusicFromURL's cache-hit path never
	// calls onSuccess, and a cache miss XHRs the virtual filename as a URL.
	var data = buffer instanceof ArrayBuffer ? buffer : (buffer.buffer || buffer);
	var subsong = track && typeof track.subsong === 'number' ? track.subsong : 0;
	try {
		var ready = player.prepareTrackForPlayback(cacheName, data, { track: subsong });
		if (!ready && !(typeof player.isWaitingForFile === 'function' && player.isWaitingForFile())) {
			throw new Error('TRACK_LOAD_FAILED');
		}
	} catch (e) {
		console.error('zxtune prepareTrackForPlayback failed', e);
		throw new Error('TRACK_LOAD_FAILED');
	}
	return Promise.resolve();
}

function markPlaybackStarted(trackId) {
	playing = true;
	updatePlayButton(false);
	if (trackId) {
		setRowState(trackId, true);
	}
	pendingAutoplayId = 0;
	trackLoadInProgress = false;
	startProgressTimer();
}

function beginTrackLoad(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		return;
	}

	if (resumeOnly && prepared) {
		var resumePlayer = getPlayer();
		if (resumePlayer) {
			void unlockAudioForGesture().then(function () {
				try {
					resumePlayer.resume();
				} catch (e) {
					try {
						resumePlayer.play();
					} catch (e2) {}
				}
				markPlaybackStarted(trackId);
			});
		}
		return;
	}

	if (trackLoadInProgress) {
		return;
	}
	trackLoadInProgress = true;

	void unlockAudioForGesture().then(function () {
		moduleLoaded = false;
		song = createSong(track);
		updateTexts(track);
		prepared = { id: track.id };
		updateProgressFallback(track);

		var cacheName = safeTuneFilename(track);
		return fetchTrackBuffer(track).then(function (buffer) {
			return startLoadedTrack(trackId, cacheName, buffer, track);
		});
	}).catch(function (e) {
		console.error('zxtune playback failed', e);
		alert(e && e.message === 'TRACK_NOT_FOUND'
			? 'Sorry, track not found. :('
			: 'Sorry, this track cannot be played in the browser.');
		stopEngine();
		setRowState(trackId, false);
		trackLoadInProgress = false;
	});
}

function playCurrent() {
	var p = getPlayer();
	if (!p || !prepared) {
		return;
	}
	void unlockAudioForGesture().then(function () {
		try {
			p.play();
		} catch (e) {}
		playing = true;
		updatePlayButton(false);
		startProgressTimer();
		updateProgress();
	});
}

function loadAndPlay(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		alert('Sorry, track not found.');
		return;
	}

	void ensureEngineReady().then(function () {
		if (!getPlayer()) {
			throw new Error('PLAYER_NOT_READY');
		}

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

		if (resumeOnly && prepared) {
			beginTrackLoad(trackId, true);
			return;
		}

		if (!resumeOnly) {
			stopEngine();
		}

		beginTrackLoad(trackId, resumeOnly);
	}).catch(function (e) {
		console.error('zxtune playback failed', e);
		alert('Sorry, this track cannot be played in the browser.');
		trackLoadInProgress = false;
	});
}

function PlayB(trackId) {
	trackId = parseInt(trackId, 10);
	void unlockAudioForGesture();
	if (trackId == last_track && playing) {
		pausePlayback();
		setRowState(trackId, false);
		return;
	}
	if (trackId == last_track && prepared && !playing) {
		loadAndPlay(trackId, true);
		return;
	}
	loadAndPlay(trackId, false);
}

function togglePlay() {
	void unlockAudioForGesture();
	if (playing) {
		pausePlayback();
		if (last_track) {
			setRowState(last_track, false);
		}
	} else {
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
		playCurrent();
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

function bindPlaylistUi() {
	var list = document.getElementById('tb');
	if (!list || list.getAttribute('data-zx-bound')) {
		return;
	}
	list.setAttribute('data-zx-bound', '1');
	list.addEventListener('mouseover', function (event) {
		var row = event.target.closest ? event.target.closest('.zx-track-row') : null;
		if (!row || !list.contains(row)) {
			return;
		}
		var id = row.getAttribute('data-track-id');
		if (id) {
			ShowDetails(id, 'on');
		}
	});
	list.addEventListener('mouseout', function (event) {
		var row = event.target.closest ? event.target.closest('.zx-track-row') : null;
		if (!row || !list.contains(row)) {
			return;
		}
		var related = event.relatedTarget;
		if (related && row.contains(related)) {
			return;
		}
		var id = row.getAttribute('data-track-id');
		if (id) {
			ShowDetails(id, 'off');
		}
	});
}

function bootAyPlayer() {
	if (zxtuneBooted) {
		return;
	}
	zxtuneBooted = true;
	readPlayerConfig();
	buildTrackIndex();
	bindPlaylistUi();
	if (window.addEventListener) {
		window.addEventListener('resize', updateTrackMarquee);
	}

	var trackId = getAutoplayTrackId();
	if (trackId > 0) {
		pendingAutoplayId = trackId;
		last_track = trackId;
		showPlayerBar();
		highlightTrack(trackId);
		var track = getTrack(trackId);
		if (track) {
			song = createSong(track);
			updateTexts(track);
		}
	}
	updateTrackMarquee();
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
