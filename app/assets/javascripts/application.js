// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(function() {
  $('#search-button').click(getTweets);
});

function getTweets() {
	$('#search-button').attr('disabled', true);
	$('#search-button').html('Searching...');
	$.ajax({
	  url: '/search/' + encodeURIComponent($('#q').attr('value')),
	  success: function(data, status, xhr) {
	    $('#tweets-div').html(data);
	    
	  },
	  complete: function() {
	  	$('#search-button').removeAttr('disabled');
	  	$('#search-button').html('Search');
	  }
	});
}

function getImage(url, id) {
	$.ajax({
	  url: '/getImage/?url=' + encodeURIComponent(url),
	  success: function(data, status, xhr) {
	    $('#' + id).append(data);
	  }
	});
}