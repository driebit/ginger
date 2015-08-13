
(function ($) {
   'use strict';

    $.widget("ui.foundation", {
        _init: function() {
            this.init();
        },

        init: function() {
            var self = this,
                element = self.element;

        alert('init');


        //fancybox
        $(".lightbox").fancybox({
                'openEffect': "fade",
                'autoScale': true,
                autoCenter: true,
                topRatio : ((navigator.userAgent.match(/iPad/i) != null) ? 0.1 : 0.5),
                leftRatio: ((navigator.userAgent.match(/iPad/i) != null) ? 0.1 : 0.5),
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
