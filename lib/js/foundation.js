
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


        }
    });
})(jQuery);
