
$.widget( "ui.googlemap", {

	_create: function() {

		var me = this,
			widgetElement = $(me.element),
			id = widgetElement.attr('id'),
			container = widgetElement,
			locations = jQuery.parseJSON(widgetElement.data('locations')),
			options,
			map,
			bounds = new google.maps.LatLngBounds(),
			info = new google.maps.InfoWindow({maxWidth: 250}),
			marker,
			icon,
			i,
			mc,
			mcOptions = {
				styles: [
				{
					height: 28,
					width: 28,
					url: "/lib/images/cluster-default-small.svg"
				},
				{
					height: 45,
					width: 45,
					url: "/lib/images/cluster-default.svg"
				},
				{
					height: 54,
					width: 54,
					url: "/lib/images/cluster-default-large.svg"
				}
			],
			zoomOnClick: false
		  },
			markers = [];

		options = jQuery.parseJSON(widgetElement.data('mapoptions'));

		if (!id) return false;

		if (options.blackwhite == true) {
			options.styles = [{
			   "stylers": [
					 { "saturation": -100 },
					 { "lightness": -8 },
					 { "gamma": 1.18 }
				 ]
			  }
			];

			delete options.blackwhite;
		}

		map = new google.maps.Map(document.getElementById(id), options);
		me.map = map;
		me.infowindow = null;

		// Show multiple markers with info windows
		for (i = 0; i < locations.length; i++) {

			icon = '/lib/images/marker-default.svg';

			// Add marker
			marker = new google.maps.Marker({
				position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
				icon: icon,
				zotonic_id: parseInt(locations[i].id)
			});

			//TODO: generic

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

			markers.push(marker);
		 }

		mc = new MarkerClusterer(map, markers, mcOptions);
		me.mc = mc;

		google.maps.event.addListener(mc, "clusterclick", function(cluster) {
			$.proxy(me.clicked(cluster), me);
			return false;
		 });

			console.log(locations.length);
		  if (locations.length > 1) {
			  // Center map on all locations
			  map.fitBounds(bounds);
		 } else {
			  //Center map on single location
			  options.center = new google.maps.LatLng(locations[0].lat, locations[0].lng);
			  options.zoom = !locations[0].zoom ? 10 : parseInt(locations[0].zoom);
			  map.setOptions(options);
		 }
	},


	clicked: function(cluster) {

	  var me = this,
		  markers = cluster.getMarkers(),
		  posCoordList = [],
		  markerList = [],
		  zoom = me.map.getZoom(),
		  clusterBounds = new google.maps.LatLngBounds();

		$.each(markers, function(index, marker) {
		  clusterBounds.extend(marker.position);
		  posCoordList.push(marker.position.G + ', ' + marker.position.K);
		  markerList.push(marker);
		});

	  me.markerList = markerList;

	  posCoordList = me.unique(posCoordList);

		if (posCoordList.length == 1 || zoom >= 21) {
			me.startShowInfoWindow(markerList);
			return false;
		} else {
			me.map.fitBounds(clusterBounds);
		}

	},

	unique: function(list) {
	  var result = [];
	  $.each(list, function(i, e) {
		  if ($.inArray(e, result) == -1) result.push(e);
	  });
	  return result;
	},

	startShowInfoWindow: function(markerList) {

	  var me = this,
		  html = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse elementum elit felis, sit amet finibus risus scelerisque et. Pellentesque dignissim urna vel est lacinia, vel pulvinar ex laoreet. Vestibulum in mauris a nisl sodales placerat. Cras lobortis volutpat nisi vitae bibendum. Phasellus ac velit sit amet ligula sagittis aliquam. Sed id erat non nulla egestas porttitor. Mauris nulla sem, eleifend vel risus sed, sollicitudin imperdiet neque. Nunc aliquet, nulla nec porttitor sagittis, ante nunc dapibus sem, semper lobortis nulla nisi eu nisi. Curabitur egestas est pretium sodales convallis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed non nisi sit amet massa pretium fringilla.Phasellus sed porttitor arcu. Suspendisse potenti. Aenean pharetra aliquet faucibus. Morbi placerat, ante maximus elementum pulvinar, enim turpis luctus massa, sed pellentesque ipsum nibh nec tellus. Aenean efficitur dui a magna posuere elementum. Vestibulum suscipit nisl mi, eget sagittis elit tempus ut. Vestibulum vel fermentum libero, a';
		  marker = markerList[0];

	  var ids = $.map(markerList, function(val, i) {
		return val.zotonic_id;
	  });

	  z_event('map_infobox', {ids: ids} );

	  //tmp call
	  me.showInfoWindow(markerList[0].zotonic_id, html);

	},


	showInfoWindow: function(zotonic_id, contentHTML) {

	  var me = this,
		  marker = me.getMarker(zotonic_id),
		  ibOptions = {
			content: contentHTML,
			disableAutoPan: false,
			maxWidth: 0,
			pixelOffset: new google.maps.Size(-140, 0),
			zIndex: null,
			boxStyle: { 
			 background: "red"
			 ,opacity: 0.75
			 ,width: "280px"
			 ,height: "300px"
			},
			closeBoxMargin: "10px 2px 2px 2px",
			closeBoxURL: "http://www.google.com/intl/en_us/mapfiles/close.gif",
			infoBoxClearance: new google.maps.Size(1, 1),
			isHidden: false,
			pane: "floatPane",
			enableEventPropagation: false
		};

		if (me.infowindow) me.infowindow.close();

		me.infowindow = new InfoBox(ibOptions);
		me.infowindow.open(me.map, marker);

	},

	getMarker: function(zotonic_id) {

	  var me = this,
		  marker;
	  
	  $.each(me.markerList, function(i, val) {
		if (val.zotonic_id == zotonic_id) marker = val;
	  });

	  return marker;

	}




});

