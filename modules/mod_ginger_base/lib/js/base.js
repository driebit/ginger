
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

            if (!$(event.target).closest('form[role="search"]').length) {

                var searchWidgets = $(':ui-search_suggestions'),
                    isOpen = false;

                $.each(searchWidgets, function(i, widget) {

                    var inst = $(widget).data('ui-search_suggestions');
                    if (inst && inst.isVisible()) {
                        isOpen = true;
                    }
                });

                if (isOpen) {
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
