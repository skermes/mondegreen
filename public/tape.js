player = { yt: null,
		   is_playing: false,
		   current: null,
		   initialized: false };

function ytPlayerStateChanged(state) {
	if (player.yt) {
		if (state == -1) { // unstarted	
		}
		else if (state == 0) { // ended	
			$(".play_link[href='" + player.current + "']").parent().next().children(":first").click();
		}
		else if (state == 1) { // playing
			$(".play_link[href='" + player.current + "']").parent().children("img").removeClass("buffering");
		}
		else if (state == 2) { // paused
		}
		else if (state == 3) { // buffering
			$(".play_link[href='" + player.current + "']").parent().children("img").addClass("buffering");
		}
		else if (state == 5) { // cued, ready to play
			if (player.initialized) {
				player.yt.playVideo();
			}
		}
	}
}
		   
function linkClicked(e) {
	e.preventDefault();

	var href = e.target.href;
		
	if (player.yt) {
		if (!player.current || player.current != href) {			
			player.current = href;
			player.is_playing = true;
			player.yt.loadVideoByUrl(href);
			$(".play_link").parent().removeClass("current_song");
			$("#" + e.target.id).parent().addClass("current_song");
		}
		else if (player.is_playing) {			
			player.yt.pauseVideo();
			player.is_playing = false;
		}
		else {
			player.yt.playVideo();
			player.is_playing = true;
		}
	}
}

function listClicked(e) {
	$("#" + e.target.id).children(":first").click();
}

function onYouTubePlayerReady(playerid) {
	player.yt = document.getElementById("myytplayer");
	player.yt.addEventListener("onStateChange", "ytPlayerStateChanged");
	var links = $(".play_link");
	links.click(linkClicked);	
	links.parent().click(listClicked);
	player.initialized = true;
	links.first().click();
}

function init_youtube() {
	var params = { allowScriptAccess: "always" };
	var attrs = { id: "myytplayer" };	
	var firsturl = $(".play_link").attr("href");	
	swfobject.embedSWF(firsturl, "ytapiplayer", "0", "0", "8", null, null, params, attrs);
}

function format_times() {
	$(".time").text(function(i, time) {
		var minutes = Math.floor(time / 60);
		var seconds = time - (minutes * 60);
		return minutes + ":" + seconds;
	});
}

$(document).ready(function() {
	init_youtube();
	format_times();
});