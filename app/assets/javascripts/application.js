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



$(document).ready(function() {
	init_zoom_user_lookup();
});