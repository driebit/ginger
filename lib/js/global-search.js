(function ($) {
   'use strict';

    $.widget("ui.global_search", {
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

            me.searchButton         = $('#toggle-search');
            me.searchForm           = $('form[role=search]');
            me.searchInput          = $('.do_global_search');
            me.suggestions          = $('.global-search__suggestions');

            resultsElement.removeClass('is-scrolable');

            function doSearch() {

                var val = me.element.val();

                if (!val.length) {
                    $(document).trigger('search:close');
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
                }, 300);

            }

            me.element.on('keyup', function(e) {
                if (timer) clearTimeout(timer);
                timer = setTimeout(doSearch, 300);
            });

            $(document).on('search:close', $.proxy(me._closeSearch, me));
            $(document).on('search:toggle', $.proxy(me._toggleSearch, me));
            me.searchButton.on('click', $.proxy(me._toggleSearch, me));

        },

        _closeSearch: function(event) {
            var me = this;
            me._toggleSearch(event, true);
        },

        _toggleSearch: function(event, close) {

            var me = this;

            me.searchButton.toggleClass('is-active');

            if(close) {
                me.searchForm.removeClass('is-visible');
                me.searchButton.removeClass('is-active');
            } else {
                if(me.searchButton.hasClass('is-active')) {
                    me.searchForm.toggleClass('is-visible');
                } else {
                    me.searchForm.toggleClass('is-visible');

                }
            }

            me.searchInput.val('');
            me.suggestions.hide();

            setTimeout(function(){
                 me.searchInput.focus();
            }, 100);

            return false;
        },

        isVisible: function() {
            var me = this;
            return me.searchForm.hasClass('is-visible');
        }


    });
})(jQuery);
