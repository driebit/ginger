
(function ($) {
   'use strict';

    $.widget("ui.foundation", {

        _init: function() {
            this.init();
        },

        init: function() {
            var me = this,
                element = me.element;

            //fancybox
            $(".lightbox").fancybox({
                    'openEffect': "fade",
                    'autoScale': true,
                    autoCenter: true,
                    helpers : {
                        overlay : {
                            css : {
                                'background' : 'rgba(246, 246, 246, 0.75)'
                            },
                        locked: false
                    }
                }
            });


            $(document).on('click', $.proxy(me._documentClick, me, event));
            $(document).on('keyup', $.proxy(me._documentKeyUp, me, event));

        },

        _documentClick: function(event) {

            var me = this;

            if (!$(event.target).closest('.global-nav').length) {

                var globalSearchWidget = $(':ui-global_search').data('ui-global_search');

                if (globalSearchWidget.isVisible()) {

                    console.log('is visible');

                    //$(document).trigger('search:close');
                }
            }
        },

        _documentKeyUp: function(event) {

            if(event.keyCode == 27 ) {
                $(document).trigger('search:close');
            }
        },

        // widgetEvents: function() {

        //     $(document).on('search:close', function() {

        //         var globalNavWidget = $(':ui-global_nav').data('ui-global_nav');

        //         if(globalNavWidget) {
        //             globalNavWidget._toggleSearch();
        //         }

        //     });

        // }

    });
})(jQuery);
