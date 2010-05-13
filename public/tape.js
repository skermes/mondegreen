player = { yt: null,
		   is_playing: false,
		   current: null };

function ytPlayerStateChanged(state) {
	if (player.yt) {
		if (state == -1) { // unstarted	
		}
		else if (state == 0) { // ended	
			$(".play_link[href='" + player.current + "']").parent().next().children(":first").click();
		}
		else if (state == 1) { // playing
		}
		else if (state == 2) { // paused
		}
		else if (state == 3) { // buffering
		}
		else if (state == 5) { // cued, ready to play
			player.yt.playVideo();
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

function onYouTubePlayerReady(playerid) {
	player.yt = document.getElementById("myytplayer");
	player.yt.addEventListener("onStateChange", "ytPlayerStateChanged");
	$(".play_link").click(linkClicked);
}

function init() {
	var params = { allowScriptAccess: "always" };
	var attrs = { id: "myytplayer" };
	
	var firsturl = $(".play_link").attr("href");
	
	swfobject.embedSWF(firsturl, "ytapiplayer", "425", "356", "8", null, null, params, attrs);
}

$(document).ready(init);