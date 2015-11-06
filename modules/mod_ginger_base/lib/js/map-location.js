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
                    address;

                address = [
                    [me.element.attr('data-street1'), me.element.attr('data-street2')].join(' '),
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
                    marker;

              me.map = new google.maps.Map(me.element[0], {
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
                });

                marker = new google.maps.Marker({
                    map: me.map,
                    draggable: true,
                    position: latLng
                });


                if (me.options.recenter == true) {
                    google.maps.event.addListenerOnce(me.map, "projection_changed", function() {
                        me.recenterMap();
                    });
                }

            },


            buildStreetView: function(latLng) {

                var me = this,
                    streetViewService = new google.maps.StreetViewService(),
                    STREETVIEW_MAX_DISTANCE = 100;

                streetViewService.getPanoramaByLocation(latLng, STREETVIEW_MAX_DISTANCE, function (streetViewPanoramaData, status) {
                    if (status === google.maps.StreetViewStatus.OK) {
                          me.panorama = new google.maps.StreetViewPanorama(
                          me.element[0], {
                            position: latLng,
                            pov: {heading: 165, pitch: 0},
                            zoom: 1
                          });
                    } else {
                        if (me.options.fallback == true) {
                            me.buildMap(latLng);
                        }
                    }
                });

            },


            recenterMap: function(map) {

                /* todo */
                return false;

                var me = this,
                    masthead = $(me.element),
                    mastheadHeight = masthead[0].clientHeight,
                    mastheadOffsetTop = masthead[0].offsetTop,
                    mainContentOffsetTop = $('.' + me.element.data('main-content-class'))[0].offsetTop,
                    offsetY = (mastheadHeight / 2) - ((mainContentOffsetTop - mastheadOffsetTop) / 2),
                    centerPoint = map.getProjection().fromLatLngToPoint(map.getCenter()),
                    offsetPoint = new google.maps.Point(0, offsetY / Math.pow(2, map.getZoom())),
                    newCenterPoint = new google.maps.Point(centerPoint.x, centerPoint.y + offsetPoint.y);

                    map.setCenter(map.getProjection().fromPointToLatLng(newCenterPoint));
            }
            
    });
})(jQuery);
