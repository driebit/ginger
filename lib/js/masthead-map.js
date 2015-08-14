(function ($) {
    'use strict';

    $.widget('ui.masthead_map', {
        _create: function () {
            var element = this.element;

            function checkGoogleVar () {
                window.setTimeout(function () {
                    if (window.google) {
                        geocodeAddress();
                    } else {
                        checkGoogleVar();
                    }
                }, 100);
            }

            checkGoogleVar();

            function geocodeAddress () {
                var geocoder = new google.maps.Geocoder(),
                    address;

                address = [
                    [element.attr('data-street1'), element.attr('data-street2')].join(' '),
                    element.attr('data-postcode'),
                    element.attr('data-city'),
                    element.attr('data-country')
                ];

                geocoder.geocode({
                    address: address.join(', ')
                }, function(results, status) {
                    if (status === google.maps.GeocoderStatus.OK && results.length > 0) {
                        buildMap(results[0].geometry);
                    }
                });
            }

            function buildMap (geometry) {
                var map,
                    marker,
                    latLng = geometry.location;

                map = new google.maps.Map(element[0], {
                    zoom: 17,
                    center: latLng,
                    mapTypeId: google.maps.MapTypeId.SATELLITE,
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
                    map: map,
                    draggable: true,
                    position: latLng
                });

                google.maps.event.addListenerOnce(map, "projection_changed", function() {
                    recenterMap(map);
                });
            }

            function recenterMap (map) {
                var masthead = $('.page__masthead'),
                    mastheadHeight = masthead[0].clientHeight,
                    mastheadOffsetTop = masthead[0].offsetTop,
                    mainContentOffsetTop = $('.page__main-content')[0].offsetTop,
                    offsetY = (mastheadHeight / 2) - ((mainContentOffsetTop - mastheadOffsetTop) / 2),
                    centerPoint = map.getProjection().fromLatLngToPoint(map.getCenter()),
                    offsetPoint = new google.maps.Point(0, offsetY / Math.pow(2, map.getZoom())),
                    newCenterPoint = new google.maps.Point(centerPoint.x, centerPoint.y + offsetPoint.y);

                map.setCenter(map.getProjection().fromPointToLatLng(newCenterPoint));
            }
        }
    });
})(jQuery);
