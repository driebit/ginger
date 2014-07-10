function ginger_map(options) {

	var locations = options.locations,
		singleMarker = false;

	// Set zoom & center when displaying a single marker.
	if (locations.length == 1) {
		options.center = new google.maps.LatLng(locations[0].lat, locations[0].lng);
		options.zoom = parseInt(locations[0].zoom);
		singleMarker = true;
	}

	// Init map
	var map = new google.maps.Map(document.getElementById(options.container), options);

	var bounds = new google.maps.LatLngBounds(),
		info = new google.maps.InfoWindow({maxWidth: 250}),
		marker,
		i;

	// Show markers on map
	for (i = 0; i < locations.length; i++) {
		// Create marker
		marker = new google.maps.Marker({
			map: map,
			position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
			animation: google.maps.Animation.DROP,
			icon: '/lib/images/marker.png'
		});

		// Extend map bounds to include each marker
		if (!singleMarker) {
			bounds.extend(marker.position);
		}

		// Add a info window to the marker
		google.maps.event.addListener(marker, 'click', (function(marker, i) {
			return function() {
				var content = '<a href="' + locations[i].url + '" style="display: block; text-decoration: none; color: #58595b; font-weight: normal; font-size: 1em;"><h4 class="item-title">' + locations[i].title + '<h4><p style="font-weight: normal; font-size: 1em;">' + locations[i].summary + '</p></a>';
				info.setContent(content);
				info.open(map, marker);
			}
		})(marker, i));
	}

	// Fit the map to the extended bounds
	if (!singleMarker) {
		map.fitBounds(bounds);
	}
}