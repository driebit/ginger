
(function ($) {
   'use strict';

    $.widget("ui.foundation", {
        _init: function() {
            this.init();
        },

        init: function() {
            var self = this,
                element = self.element;

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

            self.widgetEvents();

        },


        widgetEvents: function() {

            $(document).on('search:close', function() {
                
                var globalNavWidget = $(':ui-global_nav').data('ui-global_nav');
                
                if(globalNavWidget) {
                    globalNavWidget.toggleSearch();
                }

            });

        }


    });
})(jQuery);
