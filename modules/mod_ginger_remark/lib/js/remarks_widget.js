(function ($) {
   'use strict';

    $.widget( "ui.remarks_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);

                widgetElement.on('click', '.remark-new', function() {
                    z_event('new_remark');
                    return false;
                });

                $(document).on('remark:editing', function() {
                    //alert('hoi');
                    $('.remark-new').hide();
                });

                $(document).on('remark:viewing', function() {
                    $('.remark-new').show();
                });

        }

    });
})(jQuery);
