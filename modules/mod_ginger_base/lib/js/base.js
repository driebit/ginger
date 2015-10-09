
(function ($) {
   'use strict';

    $.widget("ui.base", {

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
                    'margin': 50,
                    'autoCenter': true,
                    'helpers' : {
                        'overlay' : {
                            'css' : {
                                'background' : 'rgba(246, 246, 246, 0.75)'
                            },
                        locked: false
                    }
                }
            });

            $(document).on('click', $.proxy(me._documentClick, me));
            $(document).on('keyup', $.proxy(me._documentKeyUp, me));

        },

        _documentClick: function(event) {

            var me = this;

            if (!$(event.target).closest('.global-nav').length) {

                var globalSearchWidget = $(':ui-global_search').data('ui-global_search');

                if (globalSearchWidget.isVisible()) {
                    $(document).trigger('search:close');
                }

                $(document).trigger('menu:close');
            }

        },

        _documentKeyUp: function(event) {

            if(event.keyCode == 27 ) {
                $(document).trigger('search:close');
                $(document).trigger('menu:close');
            }
        }


    });
})(jQuery);
