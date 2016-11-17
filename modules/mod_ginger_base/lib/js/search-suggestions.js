(function ($) {
   'use strict';

    $.widget("ui.search_suggestions", {
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
                paramToggleButton = '#' + element.data('param-togglebutton'),
                windowHeight = $(window).height();

                me.toggleButton         = $(paramToggleButton),
                me.searchForm           = $(element.closest('form')),
                me.searchInput          = element,
                me.suggestions          = $('#' + paramResults);

            me.suggestions.removeClass('is-scrolable');
            me.suggestions.hide();

            function doSearch() {

                var val = me.element.val();

                if (val.length == 0) {
                    me.suggestions.hide();
                    return;
                }

                z_event(paramWire, {value: val});

                setTimeout(function(){
                    me.suggestions.show(0, function(){

                        if (me.suggestions.outerHeight() > windowHeight) {
                            me.suggestions.addClass('is-scrollable');
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

            if (me.toggleButton != undefined) me.toggleButton.on('click', $.proxy(me._toggleSearch, me));

        },

        _closeSearch: function(event) {
            var me = this;
            me._toggleSearch(event, true);
        },

        _toggleSearch: function(event, close) {

            var me = this;

            if (me.toggleButton) me.toggleButton.toggleClass('is-active');

            if(close) {
                me.suggestions.hide();
                me.searchForm.removeClass('is-visible');
                if (me.toggleButton) me.toggleButton.removeClass('is-active');
            } else {
                me.searchForm.toggleClass('is-visible');
            }

            me.searchInput.val('');
            me.suggestions.hide();

            if (me.isVisible()) {
                me.searchForm.on('transitionend', function () {
                    me.searchInput.focus();
                });
            }

            $(document).trigger('search:toggled');

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
