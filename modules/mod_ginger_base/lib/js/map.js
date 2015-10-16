
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
                    height: 53,
                    width: 53,
                    url: "http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/images/m1.png"
                }
            ]},
            markers = [];

        options = jQuery.parseJSON(widgetElement.data('mapoptions'));

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

        // Show multiple markers with info windows
        for (i = 0; i < locations.length; i++) {
           
            icon = '/lib/images/marker-default.png';

            // Add marker
            marker = new google.maps.Marker({
                position: new google.maps.LatLng(locations[i].lat, locations[i].lng),
                icon: icon
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

            markers.push(marker);
         }

         mc = new MarkerClusterer(map, markers, mcOptions);

         if (locations.length > 1) {
             // Center map on all locations
             map.fitBounds(bounds);
         } else {
             //Center map on single location
             options.center = new google.maps.LatLng(locations[0].lat, locations[0].lng);
             options.zoom = !locations[0].zoom ? 10 : parseInt(locations[0].zoom);
             map.setOptions(options);
        }
    }

});

