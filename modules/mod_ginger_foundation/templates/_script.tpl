{% lib
    "bootstrap/js/bootstrap.min.js"
    "js/qlobber.js"
    "js/pubzub.js"
    "js/modules/z.live.js"
    "js/vendors/jquery.fancybox.min.js"
    "js/vendors/jquery.fancybox-media.js"
    "js/base.js"
    "js/global-nav.js"
    "js/search-suggestions.js"
    "js/content-group-nav.js"
    "js/foldout.js"
    "js/foundation.js"
    "js/carousel.js"
    "js/map-location.js"
    "js/parallax.js"
    "js/anchor.js"
    "js/expand.js"
    "js/vendors/flowplayer-3.2.12.min.js"
    "js/vendors/slick.min.js"
    "js/vendors/purl.js"
    "js/search/search_ui.js"
    "js/search/search.js"
    "js/search/components/input-text.js"
    "js/search/components/sort.js"
    "js/search/components/pager.js"
    "js/search/components/types.js"
    "js/mail-decode.js"
%}

{% if m.modules.active.mod_geo %}
    <script src="//maps.googleapis.com/maps/api/js?key={{ m.config.mod_geo.api_key.value|escape }}&amp;libraries=places&amp;language=nl&amp;v=3"></script>
    {% lib
        "js/vendors/infobox_packed.js"
        "js/vendors/markerclusterer.js"
        "js/map.js"
    %}
{% endif %}

