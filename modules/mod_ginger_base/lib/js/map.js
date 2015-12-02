
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
			icon,
			i,
			mc,
			mcOptions;

		markers = [];
        me.id = id;
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

		if (options.disabledefaultui) options.disableDefaultUI = true;

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
		  };

		if (options.gridsize) {
			mcOptions.gridSize = parseInt(options.gridsize);
		}

		map = new google.maps.Map(document.getElementById(id), options);
		me.map = map;
		me.infowindow = null;
		me.markers = markers;

		// Show multiple markers with info windows
		for (i = 0; i < locations.length; i++) {

			icon = '/lib/images/marker-default.png';

			var marker = new google.maps.Marker({
				position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
				icon: icon,
				zotonic_id: parseInt(locations[i].id)
			});

			marker.addListener('click', function() {
				var markerList = [];
				markerList.push(this);
				me.startShowInfoWindow(markerList);
			});

			bounds.extend(marker.position);

			markers.push(marker);
		 }

		mc = new MarkerClusterer(map, markers, mcOptions);
		me.mc = mc;

		google.maps.event.addListener(mc, "clusterclick", function(cluster) {
			$.proxy(me.clusterClicked(cluster), me);
			return false;
		});

		if (locations.length == 1) {
			var zoomLevel = (!locations[0].zoom ? 15 : parseInt(locations[0].zoom));
			google.maps.event.addListenerOnce(map, 'bounds_changed', function(event) {
				this.setZoom(zoomLevel);
			});
		}

		map.fitBounds(bounds);

	},

	clusterClicked: function(cluster) {

		var me = this,
			markers = cluster.getMarkers(),
			posCoordList = [],
			markerList = [],
			zoom = me.map.getZoom(),
			clusterBounds = new google.maps.LatLngBounds();

			$.each(markers, function(index, marker) {
				clusterBounds.extend(marker.position);
				posCoordList.push(marker.position.lat() + ', ' + marker.position.lng());
				markerList.push(marker);
			});

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
		  marker = markerList[0];

		var ids = $.map(markerList, function(val, i) {
			return val.zotonic_id;
	  	});

    	z_event('map_infobox', {ids: ids, element: me.id});

	},

	showInfoWindow: function(zotonic_id, contentHTML) {

	  var me = this,
		  marker = me.getMarker(zotonic_id),
		  ibOptions = {
            content: contentHTML,
			disableAutoPan: false,
			maxWidth: 0,
			maxHeight: 200,
			pixelOffset: new google.maps.Size(-140, 0),
			zIndex: null,
				closeBoxURL: "/lib/images/infobox-close.svg",
			infoBoxClearance: new google.maps.Size(1, 1),
			isHidden: false,
			pane: "floatPane",
			enableEventPropagation: false
		};

		me.map.setCenter(marker.getPosition());

		if (me.infowindow) me.infowindow.close();

		me.infowindow = new InfoBox(ibOptions);
		me.infowindow.open(me.map, marker);

	},

	getMarker: function(zotonic_id) {

	  var me = this,
		  marker;

	  $.each(me.markers, function(i, val) {
		if (val.zotonic_id == zotonic_id) marker = val;
	  });

	  return marker;
	},

	enableUI: function() {
		this.map.set('disableDefaultUI', false);
	},

	removeStyles: function() {
		this.map.set('styles', '');
	}

});

