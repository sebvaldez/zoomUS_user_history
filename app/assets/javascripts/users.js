
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
	console.log('clicked!');
	$('#search-participants-list').on('ajax:success', function(event, data, status){
		$('#modal-of-participants').replaceWith(data);
		console.log(data);
	});

	$('#search-participants-list').on('ajax:error', function(event, data, status){
		console.log(data);
	});
}
