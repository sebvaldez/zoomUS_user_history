// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .


var init_zoom_user_lookup;

init_zoom_user_lookup = function() {

	$("#zoom-user-lookup-form").on('ajax:success', function(event, data, status) {
		$("#zoom-user-lookup").replaceWith(data);
		init_zoom_user_lookup();
	});

	$("#zoom-user-lookup-form").on("ajax:error", function(event, data, status) {
		$("#zoom-user-lookup-results").replaceWith(' ');
		$("#zoom-user-lookup-errors").replaceWith("Zoom User was not located!");
	});
}

var list_of_participants = function() {
	$('.search-participants-list').on('ajax:success', function(event, data, status){
		$('#modal-results').replaceWith(data);
		list_of_participants();
	});

	$('#search-participants-list').on('ajax:error', function(event, data, status){
		console.log(data);
		console.log("there was an error");
	});
}

// Test manual ajax call
var get_list = function(meeting_id) {

	var url = '/meeting_participants/' + meeting_id;

	$.ajax({
		type: 'GET',
		url: url,
		success: function(response){
			$('#modal-results').append(response);
		},
		error: function(response){
			console.log('the was an error with requesting meeting_id');
		}
	});

}


$(document).ready(function() {

	// Run for user look up
	init_zoom_user_lookup();

	// init ajax success if participant count was clicked
	document.getElementById('users-meetings').addEventListener('click', function(e){
		e.preventDefault();
		if (e.target.nodeName === 'A') {
			var uuid = e.target.href.split('/').slice(-1)[0];
			get_list(uuid);
		}
	});

	// Clear out modal on close
	$('.modal').on('hidden.bs.modal', function () {
    $('#modal-results').empty();
	});

});








