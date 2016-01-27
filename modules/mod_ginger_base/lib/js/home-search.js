(function ($) {
   'use strict';

    $.widget("ui.home_search", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                element = me.element,
                timer = null,
                prevVal = null,
                paramResults = element.data('param-results'),
                paramWire = element.data('param-wire'),
                resultsElement = $('#' + paramResults),
                windowHeight = $(window).height();

            me.searchButton         = $('.home__search-submit');
            me.searchForm           = $('.home__search');
            me.searchInput          = $('.do_home_search');
            me.suggestions          = $('.home__search__suggestions');

            resultsElement.removeClass('is-scrolable');
            resultsElement.hide();

            function doSearch() {

                var val = me.element.val();

                if (val.length == 0) {
                    me.suggestions.hide();
                    return;
                }

                if (prevVal && val == prevVal || !val.length) {
                    return;
                }

                prevVal = val;
                z_event(paramWire, {value: val});

                setTimeout(function(){
                    resultsElement.show(0, function(){
                        if (resultsElement.outerHeight() > windowHeight) {
                            resultsElement.addClass('is-scrollable');
                        }
                    });
                }, 500);

            }

            me.element.on('keyup', function(e) {
                if (timer) clearTimeout(timer);
                timer = setTimeout(doSearch, 300);
            });

            $(document).on('click', function(){
                resultsElement.hide();
            });

        }
    });
})(jQuery);
