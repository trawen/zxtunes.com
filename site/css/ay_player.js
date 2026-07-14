// ZXTunes HTML5 AY/FYM player (ayumi + fym.js, ym.mmcm.ru based)

var pl = [];
var cm = [];
var id_comment = 0;
var start_time = 0;
var last_track = 0;
var id_thanks = 0;
var tht = ["Thank you!", "Speccy rulez!", "Spectrum alive!", "8-bit never die!"];

var ayumi, ayumi2, song;
var isrCounter, isrStep;
var audioContext, audioNode;
var isTurbo = false;
var playing = false;
var repeat = false;
var shuffle = false;
var timeElapsed = false;
var isYM = true;
var chipMode = 0;
var shuffleOrder = [];
var shufflePos = 0;
var tracksById = {};
var autoplayUnlockBound = false;
var pendingAutoplayId = 0;
var autoplay = 0;
var author_id = 0;
var author_name = "";
var first_track = 0;
var zxtunesPlaylist = [];

function buildTrackIndex() {
	tracksById = {};
	if (typeof zxtunesPlaylist === "undefined") {
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
	var bar = document.getElementById("zx_ay_player_wrap");
	if (bar) {
		bar.className = "zx-ay-player-wrap zx-ay-visible";
		document.body.className = (document.body.className + " zx-ay-playing").replace(/\s+/g, " ").trim();
	}
}

function updatePlayButton(paused) {
	var button = document.getElementById("b_play");
	if (!button) {
		return;
	}
	button.className = paused ? "b_control b_play" : "b_control b_pause";
}

function setRowState(trackId, isPlaying) {
	var btn = document.getElementById("m" + trackId);
	if (!btn) {
		return;
	}
	if (isPlaying) {
		btn.className = "stop";
		pl[trackId] = 1;
	} else {
		btn.className = "play";
		pl[trackId] = 0;
	}
}

function highlightTrack(trackId) {
	var rows = document.querySelectorAll(".zx-track-row");
	for (var i = 0; i < rows.length; i++) {
		rows[i].classList.remove("zx-ay-track-active");
	}
	var row = document.getElementById("s" + trackId);
	if (row) {
		row.classList.add("zx-ay-track-active");
	}
}

function focusPlaylistTrack(trackId) {
	trackId = parseInt(trackId, 10);
	if (!trackId) {
		return;
	}
	highlightTrack(trackId);
	var row = document.getElementById("s" + trackId);
	if (row && row.scrollIntoView) {
		row.scrollIntoView({ block: "center", behavior: "smooth" });
	}
}

function updatePan() {
	var a = 0.25, b = 0.5, c = 0.75;
	var mode = chipMode % 6;
	var table = [[a, b, c], [a, c, b], [b, a, c], [b, c, a], [c, a, b], [c, b, a]];
	if (ayumi) {
		ayumi.setPan(0, table[mode][0], 0);
		ayumi.setPan(1, table[mode][1], 0);
		ayumi.setPan(2, table[mode][2], 0);
	}
	if (ayumi2) {
		ayumi2.setPan(0, table[mode][0], 0);
		ayumi2.setPan(1, table[mode][1], 0);
		ayumi2.setPan(2, table[mode][2], 0);
	}
}

function updateState(renderer, r) {
	renderer.setTone(0, (r[1] << 8) | r[0]);
	renderer.setTone(1, (r[3] << 8) | r[2]);
	renderer.setTone(2, (r[5] << 8) | r[4]);
	renderer.setNoise(r[6]);
	renderer.setMixer(0, r[7] & 1, (r[7] >> 3) & 1, r[8] >> 4);
	renderer.setMixer(1, (r[7] >> 1) & 1, (r[7] >> 4) & 1, r[9] >> 4);
	renderer.setMixer(2, (r[7] >> 2) & 1, (r[7] >> 5) & 1, r[10] >> 4);
	renderer.setVolume(0, r[8] & 0xf);
	renderer.setVolume(1, r[9] & 0xf);
	renderer.setVolume(2, r[10] & 0xf);
	renderer.setEnvelope((r[12] << 8) | r[11]);
	if (r[13] != 0xff) {
		renderer.setEnvelopeShape(r[13]);
	}
}

function updateProgress() {
	if (!song) {
		return;
	}
	var progress = song.getProgress();
	var left = document.getElementById("track_progress_left");
	var right = document.getElementById("track_progress_right");
	if (left && right) {
		var k = Math.round(progress * 10000) * 0.01;
		left.style.width = k + "%";
		right.style.width = (100 - k) + "%";
	}
	var time = timeElapsed ? song.getTimeElapsed() : song.getTime();
	var trackTime = document.getElementById("track_time");
	if (trackTime) {
		trackTime.textContent = time;
	}
}

function decodeEntities(text) {
	if (!text) {
		return "";
	}
	var ta = document.createElement("textarea");
	ta.innerHTML = text;
	return ta.value;
}

function updateTrackMarquee() {
	var name = document.getElementById("track_name");
	if (!name) {
		return;
	}
	var wrap = name.parentNode;
	if (!wrap || !wrap.classList || !wrap.classList.contains("track_name_wrap")) {
		return;
	}
	name.classList.remove("track_name--scroll");
	name.style.removeProperty("--marquee-shift");
	// Measure natural text width against the clip container.
	name.style.display = "inline-block";
	name.style.maxWidth = "none";
	name.style.width = "max-content";
	name.style.overflow = "visible";
	var overflow = name.scrollWidth - wrap.clientWidth;
	name.style.removeProperty("display");
	name.style.removeProperty("max-width");
	name.style.removeProperty("width");
	name.style.removeProperty("overflow");
	if (overflow > 4) {
		name.style.setProperty("--marquee-shift", "-" + overflow + "px");
		name.classList.add("track_name--scroll");
	}
}

function updateTexts(track) {
	var name = document.getElementById("track_name");
	if (!name) {
		return;
	}
	var title = track.title ? decodeEntities(track.title) : "";
	var label = decodeEntities(author_name) + " – " + decodeEntities(track.filename);
	if (title) {
		label += " – " + title;
	}
	name.textContent = label;
	document.title = label + " : ZXTunes";
	updateTrackMarquee();
}

function fillBuffer(e) {
	var finished = false;
	var left = e.outputBuffer.getChannelData(0);
	var right = e.outputBuffer.getChannelData(1);
	for (var i = 0; i < left.length; i++) {
		isrCounter += isrStep;
		if (isrCounter >= 1) {
			var regs = song.getNextFrame();
			updateState(ayumi, regs[0]);
			if (isTurbo) {
				updateState(ayumi2, regs[1]);
			}
			isrCounter--;
			finished |= regs[2];
			updateProgress();
		}
		ayumi.process();
		ayumi.removeDC();
		if (isTurbo) {
			ayumi2.process();
			ayumi2.removeDC();
			left[i] = (ayumi.left + ayumi2.left) * 0.5;
			right[i] = (ayumi.right + ayumi2.right) * 0.5;
		} else {
			left[i] = ayumi.left;
			right[i] = ayumi.right;
		}
	}
	if (!repeat && finished) {
		NextTrack();
	}
}

function startPlayback(buffer, fileName, track) {
	song = new FYMReader(buffer, fileName);
	var sampleRate = audioContext.sampleRate;
	isrStep = song.getFrameRate() / sampleRate;
	isrCounter = 0;
	ayumi = new Ayumi();
	ayumi.configure(isYM, song.getClockRate(), sampleRate);
	isTurbo = song.getTurbo();
	if (isTurbo) {
		ayumi2 = new Ayumi();
		ayumi2.configure(isYM, song.getClockRate(), sampleRate);
	}
	updatePan();
	audioNode.connect(audioContext.destination);
	updateTexts(track);
	updateProgress();
}

function disconnectAudio() {
	if (audioNode) {
		try {
			audioNode.disconnect();
		} catch (e) {}
	}
	if (audioContext) {
		try {
			audioContext.close();
		} catch (e) {}
		audioContext = null;
		audioNode = null;
	}
}

function pausePlayback() {
	disconnectAudio();
	playing = false;
	updatePlayButton(true);
}

function stopEngine() {
	pausePlayback();
	song = null;
	ayumi = null;
	ayumi2 = null;
}

function recordPlayStat(prevTrack) {
	if (!prevTrack || !pl[prevTrack]) {
		return;
	}
	var now = new Date();
	if (now - start_time <= 5000) {
		return;
	}
	var aid = document.getElementById("a" + prevTrack);
	var authorId = aid ? aid.textContent : author_id;
	var downloads = document.getElementById("dw" + prevTrack);
	if (downloads) {
		downloads.textContent = parseInt(downloads.textContent || "0", 10) + 1;
	}
	if (typeof $ !== "undefined") {
		$.post("/playing_up.php", {id: prevTrack, id_author: authorId, type: 2});
	}
}

function updatePlayUrl(trackId) {
	if (typeof author_id === "undefined" || !author_id || !trackId) {
		return;
	}
	try {
		var url = new URL(window.location.href);
		url.searchParams.set("id", String(author_id));
		url.searchParams.set("play", String(trackId));
		if (!url.searchParams.get("md")) {
			url.searchParams.set("md", "1");
		}
		var next = url.pathname + url.search + url.hash;
		var current = window.location.pathname + window.location.search + window.location.hash;
		if (next !== current) {
			history.replaceState({ play: trackId }, "", next);
		}
	} catch (e) {}
}

function getAutoplayTrackId() {
	var id = parseInt(autoplay, 10);
	if (id > 0) {
		return id;
	}
	try {
		id = parseInt(new URLSearchParams(window.location.search).get("play"), 10);
		return id > 0 ? id : 0;
	} catch (e) {
		return 0;
	}
}

function markPlaybackStarted(trackId) {
	playing = true;
	updatePlayButton(false);
	if (trackId) {
		setRowState(trackId, true);
	}
	pendingAutoplayId = 0;
}

function markPlaybackWaiting(trackId) {
	playing = false;
	updatePlayButton(true);
	if (trackId) {
		setRowState(trackId, false);
	}
	pendingAutoplayId = trackId;
}

function bindAutoplayUnlock(retryFn) {
	if (autoplayUnlockBound) {
		return;
	}
	autoplayUnlockBound = true;
	var unlock = function() {
		document.removeEventListener("pointerdown", unlock, true);
		document.removeEventListener("keydown", unlock, true);
		autoplayUnlockBound = false;
		retryFn();
	};
	document.addEventListener("pointerdown", unlock, true);
	document.addEventListener("keydown", unlock, true);
}

function ensureAudioRunning(done, onBlocked) {
	if (!audioContext) {
		done();
		return;
	}
	var resume = audioContext.state === "suspended" ? audioContext.resume() : Promise.resolve();
	resume.then(function() {
		if (audioContext.state === "running") {
			done();
			return;
		}
		if (onBlocked) {
			onBlocked();
		}
		bindAutoplayUnlock(done);
	}).catch(function() {
		if (onBlocked) {
			onBlocked();
		}
		bindAutoplayUnlock(done);
	});
}

function beginTrackLoad(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		return;
	}

	var onBlocked = function() {
		markPlaybackWaiting(trackId);
	};

	if (resumeOnly && song) {
		ensureAudioRunning(function() {
			audioNode.connect(audioContext.destination);
			markPlaybackStarted(trackId);
		}, onBlocked);
		return;
	}

	var req = new XMLHttpRequest();
	req.open("GET", track.url, true);
	req.responseType = "arraybuffer";
	req.onload = function() {
		if (req.response) {
			ensureAudioRunning(function() {
				startPlayback(req.response, track.filename + ".fym", track);
				markPlaybackStarted(trackId);
			}, onBlocked);
		}
	};
	req.onerror = function() {
		alert("Sorry, track not found. :(");
		stopEngine();
		setRowState(trackId, false);
	};
	req.send(null);
}

function loadAndPlay(trackId, resumeOnly) {
	var track = getTrack(trackId);
	if (!track) {
		alert("Sorry, track not found.");
		return;
	}

	var AudioContextHandle = window.AudioContext || window.webkitAudioContext;
	if (!AudioContextHandle) {
		alert("Web Audio API is not supported by your browser.");
		return;
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

	if (resumeOnly && song && audioContext && audioNode) {
		ensureAudioRunning(function() {
			audioNode.connect(audioContext.destination);
			markPlaybackStarted(trackId);
		}, function() {
			markPlaybackWaiting(trackId);
		});
		return;
	}

	if (audioContext) {
		disconnectAudio();
	}

	audioContext = new AudioContextHandle();
	audioNode = audioContext.createScriptProcessor(16384, 0, 2) || audioContext.createJavaScriptNode(16384, 0, 2);
	audioNode.onaudioprocess = fillBuffer;
	beginTrackLoad(trackId, resumeOnly);
}

function PlayB(trackId) {
	trackId = parseInt(trackId, 10);
	if (trackId == last_track && playing) {
		pausePlayback();
		setRowState(trackId, false);
		return;
	}
	if (trackId == last_track && song && !playing) {
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
	} else if (last_track && song) {
		loadAndPlay(last_track, true);
	} else if (pendingAutoplayId || last_track) {
		PlayB(pendingAutoplayId || last_track);
	} else if (first_track) {
		PlayB(first_track);
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
	var button = document.getElementById("b_shuffle");
	shuffle = !shuffle;
	if (button) {
		button.style.opacity = shuffle ? "1" : "0.4";
	}
}

function playRepeat() {
	var button = document.getElementById("b_repeat");
	repeat = !repeat;
	if (button) {
		button.style.opacity = repeat ? "1" : "0.4";
	}
}

function toggleTime() {
	timeElapsed = !timeElapsed;
	updateProgress();
}

function changeProgress(event) {
	if (!song) {
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
	updateProgress();
}

function ShowDetails(nm, ev) {
	if (typeof $ === "undefined") {
		return;
	}
	if (ev == "on") {
		var pos = $("#s" + nm).position();
		$("#test" + nm).html("<div id='songinfo' style='z-index: 5; position: absolute;'><img src='images/songinfo.png' border=0></div>");
		$("#songinfo").css("top", pos.top - 25);
		$("#songinfo").css("left", pos.left + $("#s" + nm).width() + 8);
	} else {
		$("#test" + nm).html("");
	}
}

function Rate(id) {
	if (typeof $ === "undefined" || !$("#r" + id).hasClass("rating")) {
		return;
	}
	id_thanks = id;
	$("#r" + id).removeClass("rating").addClass("r_off");
	var rating = parseInt($("#rn" + id).text() || "0", 10) + 1;
	$("#rn" + id).text(rating);
	var aid = $("#a" + id).text();
	$.post("/playing_up.php", {type: "test-request", id: id, id_author: aid, type: 1}, OpenThanks);
}

function Comm(id) {
	if (typeof $ === "undefined") {
		return;
	}
	if (cm[id]) {
		$("#c" + id).hide();
		cm[id] = 0;
	} else {
		$("#c" + id).show();
		cm[id] = 1;
		id_comment = id;
		$.post("/get_comments.php", {type: "test-request", id: id}, InsertComment);
	}
}

function InsertComment(data) {
	$("#c" + id_comment).html(data);
}

function OpenThanks() {
	if (typeof $ === "undefined") {
		return;
	}
	var pos = $("#r" + id_thanks).position();
	$("#thanks1").css({top: pos.top - 40, left: pos.left - 16});
	$("#thanks2").text(tht[Math.floor(Math.random() * tht.length)]);
	$("#thanks1").fadeIn(1, function() {
		setTimeout(function() { $("#thanks1").fadeOut(500); }, 2000);
	});
}

function AddComment(id) {
	if (typeof $ === "undefined") {
		return;
	}
	var nick = $("#nick" + id).val();
	var email = $("#email" + id).val();
	var mess = $("#mess" + id).val();
	if (!nick) {
		alert("Enter <Nick>");
		return;
	}
	if (!mess) {
		alert("Enter <Message>");
		return;
	}
	var aid = $("#a" + id).text();
	$.post("/get_comments.php", {type: "test-request", id: id, nick: nick, email: email, mess: mess, id_author: aid}, InsertComment);
	var comments = parseInt($("#cm" + id).text() || "0", 10) + 1;
	$("#cm" + id).text(comments);
}

function readPlayerConfig() {
	var el = document.getElementById("zxtunes-player-config");
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

function initAyPlayer() {
	readPlayerConfig();
	buildTrackIndex();
	if (window.addEventListener) {
		window.addEventListener("resize", updateTrackMarquee);
	}
	var trackId = getAutoplayTrackId();
	if (trackId > 0) {
		PlayB(trackId);
	} else {
		updateTrackMarquee();
	}
}

if (typeof $ !== "undefined") {
	$(document).ready(initAyPlayer);
} else if (document.addEventListener) {
	document.addEventListener("DOMContentLoaded", initAyPlayer);
}
