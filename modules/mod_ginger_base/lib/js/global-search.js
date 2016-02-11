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
                paramSearchButton = element.data('param-searchbutton'),
                paramSearchSuggestions = element.data('param-searchsuggestions'),
                paramFoldout = element.data('param-foldout'),
                resultsElement = $('#' + paramResults),
                windowHeight = $(window).height();


            //TODO: backwards compat
            if (paramSearchSuggestions == undefined) {

                me.foldout              = true;
                me.searchButton         = $('#toggle-search');
                me.searchForm           = $(element.closest('form')),
                me.searchInput          = element,
                me.suggestions          = $('.global-search__suggestions');

            } else {

                me.foldout              = $(paramFoldout),
                me.searchButton         = $(paramSearchButton),
                me.searchForm           = $(element.closest('form')),
                me.searchInput          = element,
                me.suggestions          = $(paramSearchSuggestions);

            }           

            resultsElement.removeClass('is-scrolable');
            resultsElement.hide();

            function doSearch() {

                var val = me.element.val();

                if (val.length == 0) {
                    me.suggestions.hide();
                    return;
                }

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

            $(document).on('search:close', $.proxy(me._closeSearch, me));
            $(document).on('search:toggle', $.proxy(me._toggleSearch, me));

            if (me.searchButton != undefined) me.searchButton.on('click', $.proxy(me._toggleSearch, me));         

        },

        _closeSearch: function(event) {
            var me = this;
            me._toggleSearch(event, true);
        },

        _toggleSearch: function(event, close) {
           
            var me = this;          

            if (me.searchButton) me.searchButton.toggleClass('is-active');

            if(close) {
                me.searchForm.removeClass('is-visible');
                me.searchButton.removeClass('is-active');
            } else {
                me.searchForm.toggleClass('is-visible');
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

            if (me.suggestions.css('display') == 'block' || me.searchForm.hasClass('is-visible')) {
                return true;
            } else {
                return false;
            }
        }
    });
})(jQuery);
