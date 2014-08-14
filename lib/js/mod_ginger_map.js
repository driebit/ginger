function ginger_map(args) {

	var container = args.container,
		locations = args.locations,
		mapOptions = args.mapOptions;

	var map = new google.maps.Map(document.getElementById(container), mapOptions),
		bounds = new google.maps.LatLngBounds(),
		info = new google.maps.InfoWindow({maxWidth: 250}),
		marker,
		icon,
		i;

	// Show multiple markers with info windows
	for (i = 0; i < locations.length; i++) {
		
		if (typeof(args.highlight) !== 'undefined' && args.highlight == i) {
			icon = '/lib/images/marker-highlight.png';
		} else {
			icon = '/lib/images/marker.png';
		}

		// Add marker
		marker = new google.maps.Marker({
			position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
			icon: icon,
			map: map
		});

		// Add an info window to the marker
		google.maps.event.addListener(marker, 'click', (function(marker, i) {
			return function() {
				info.setContent(locations[i].content);
				info.open(map, marker);
			}
		})(marker, i));

		// Extend map bounds
		if (locations.length > 1) {
			bounds.extend(marker.position);
		}
	}

	if (locations.length == 1) {
		mapOptions = {
			center: new google.maps.LatLng(locations[0].lat, locations[0].lng),
			zoom: !locations[0].zoom ? 10 : parseInt(locations[0].zoom)
		};
		map.setOptions(mapOptions);
	}

	// Fit map to bounds
	if (locations.length > 1) {
		map.fitBounds(bounds);
	}
}