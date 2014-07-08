function ginger_map(options) {

	var loc = new google.maps.LatLng(options.lat, options.lng);
	options.center = loc;

	console.log(options);

	var map = new google.maps.Map(document.getElementById(options.container), options);

	var marker = new google.maps.Marker({
		map: map,
		title: options.title,
		position: options.loc,
		animation: google.maps.Animation.DROP
	});
}