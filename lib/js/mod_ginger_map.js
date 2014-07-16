function ginger_map(options) {

	var locations = options.locations,
		loc = null;

	// Set zoom & center when displaying a single marker.
	if (locations.length == 1) {
		loc = locations[0];
		options.center = new google.maps.LatLng(loc.lat, loc.lng);
		options.zoom = !loc.zoom ? 10 : parseInt(loc.zoom);
	}

	// Init map
	var map = new google.maps.Map(document.getElementById(options.container), options);

	if (loc != null) {
		// Show single marker
		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(loc.lat, loc.lng),
			animation: google.maps.Animation.DROP,
			icon: '/lib/images/marker.png',
			map: map
		});
	} else {
		var bounds = new google.maps.LatLngBounds(),
			info = new google.maps.InfoWindow({maxWidth: 250}),
			marker,
			i;
	
		// Show multiple markers with info windows
		for (i = 0; i < locations.length; i++) {
			// Add marker
			marker = new google.maps.Marker({
				position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
				animation: google.maps.Animation.DROP,
				icon: '/lib/images/marker.png',
				map: map
			});

			// Add an info window to the marker
			google.maps.event.addListener(marker, 'click', (function(marker, i) {
				return function() {
					var content = '<a href="' + locations[i].url + '" style="display: block; text-decoration: none; color: #58595b; font-weight: normal; font-size: 1em;"><h4 class="item-title">' + locations[i].title + '<h4><p style="font-weight: normal; font-size: 1em;">' + locations[i].summary + '</p></a>';
					info.setContent(content);
					info.open(map, marker);
				}
			})(marker, i));

			// Extend map bounds
			bounds.extend(marker.position);
		}

		// Fit map to bounds
		map.fitBounds(bounds);
	}
}