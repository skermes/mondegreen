function addsong(event) {	
	var inputs = $('.songinput');
	inputs.filter(function (index) { return inputs[index].value == ''; }).first().val(event.target.id);
}

function vidUrl(id) {	
	 return 'http://www.youtube.com/watch?v=' + id.substring(id.length - 11, id.length);
}

function displaysearch(data, status) {
	if (status != 'success') {	
		return;
	}	
	
	var list = $('#results');
	list.children().remove();
	for (var i = 0; i < data.feed.entry.length; i++) {
		list.append('<li class="resultlink" id="' + vidUrl(data.feed.entry[i].id.$t) + '"><span>' + data.feed.entry[i].title.$t + '</span></li>');
	}
	
	$('.resultlink').click(addsong);
}

function dosearch() {	
	var url = 'http://gdata.youtube.com/feeds/api/videos';
	url += '?q=' + $('#query').val();
	url += '&orderby=relevance';
	url += '&alt=json';
	
	$.getJSON(url, displaysearch); 
	return false;
}

$(document).ready(function() {
	$('#search').submit(dosearch);
});