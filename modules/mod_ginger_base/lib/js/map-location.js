(function ($) {
    'use strict';

    $.widget('ui.map_location', {
        _create: function () {

        var element = $(this.element),
                me = this,
                options = jQuery.parseJSON(element.data('options')),
                map,
                panorama;

            me.options = options;
            me.element = element;

            me.panorama = panorama;
            me.map = map;

            me.checkGoogleVar();

        },

        checkGoogleVar: function() {

            var me = this;

            window.setTimeout(function () {

                if (window.google) {
                    me.geocodeAddress();
                } else {
                    me.checkGoogleVar();
                }
            }, 100);
        },

        geocodeAddress: function () {

                var me = this,
                    geocoder = new google.maps.Geocoder(),
                    address,
                    street = me.element.attr('data-street').trim();

                if (!street || street == '') return false;

                address = [
                    street = /\s*\w+(?:\s+\d+)?/.exec(street)[0],
                    me.element.attr('data-postcode'),
                    me.element.attr('data-city'),
                    me.element.attr('data-country')
                ];

                geocoder.geocode({
                    address: address.join(', ')
                }, function(results, status) {
                    if (status === google.maps.GeocoderStatus.OK && results.length > 0) {
                        me.initView(results[0].geometry);
                    }
                });
            },

            initView: function(geometry) {

                var me = this,
                    marker,
                    latLng = geometry.location;

                if (me.options.type.toLowerCase() == "streetview") {
                    me.buildStreetView(latLng);
                } else if (me.options.type.toLowerCase() == "map") {
                    me.buildMap(latLng);
                }

            },

            buildMap: function(latLng) {

                var me = this,
                    marker,
                    options = {
                        zoom: 14,
                        center: latLng,
                        disableDoubleClickZoom: true,
                        disableDefaultUI: true,
                        keyboardShortcuts: false,
                        draggable: false,
                        scrollwheel: false,
                        panControl: false,
                        rotateControl: false,
                        scaleControl: false,
                        componentRestrictions: {}
                    };

                if (me.options.blackwhite == true) {
                    options.styles = [{
                       "stylers": [
                             { "saturation": -100 },
                             { "lightness": -8 },
                             { "gamma": 1.18 }
                         ]
                      }
                    ];
                }

                me.map = new google.maps.Map(me.element[0], options);

                marker = new google.maps.Marker({
                    map: me.map,
                    draggable: true,
                    position: latLng,
                    icon: '/lib/images/marker-default.png'
                });

                if (me.options.recenter == true) {
                    google.maps.event.addListenerOnce(me.map, "projection_changed", function() {
                        me.recenterMap(me.map);
                    });
                }

            },


            buildStreetView: function(latLng) {

                var me = this,
                    streetViewService = new google.maps.StreetViewService(),
                    STREETVIEW_MAX_DISTANCE = 100;

                    streetViewService.getPanoramaByLocation(latLng, STREETVIEW_MAX_DISTANCE, function (streetViewPanoramaData, status) {

                    var panoramaLatLng = streetViewPanoramaData.location.latLng,
                        heading = google.maps.geometry.spherical.computeHeading(latLng, panoramaLatLng);

                    if (status === google.maps.StreetViewStatus.OK) {

                          me.panorama = new google.maps.StreetViewPanorama(
                          me.element[0], {
                            position: latLng,
                            pov: {heading: heading, pitch: 0},
                            zoom: 1,
                            disableDefaultUI: true
                          });
                    } else {
                        if (me.options.fallback == true) {
                            me.buildMap(latLng);
                        }
                    }

                });

            },


            recenterMap: function(map) {

                var me = this,
                    mainContentEl = $('.' + me.element.data('main-content-class'));

                    if (mainContentEl.size() == 0) return false;

                    var masthead = $(me.element),
                    mastheadHeight = masthead[0].clientHeight,
                    mastheadOffsetTop = masthead[0].offsetTop,
                    mainContentOffsetTop = mainContentEl[0].offsetTop,
                    offsetY = (mastheadHeight / 2) - ((mainContentOffsetTop - mastheadOffsetTop) / 2),
                    centerPoint = map.getProjection().fromLatLngToPoint(map.getCenter()),
                    offsetPoint = new google.maps.Point(0, offsetY / Math.pow(2, map.getZoom())),
                    newCenterPoint = new google.maps.Point(centerPoint.x, centerPoint.y + offsetPoint.y);

                    map.setCenter(map.getProjection().fromPointToLatLng(newCenterPoint));
            }
            
    });
})(jQuery);
