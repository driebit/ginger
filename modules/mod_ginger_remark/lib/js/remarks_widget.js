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

                $(document).on('remark:editing', function(event, remark_id) {
                    $('.remark-edit').hide();
                    $('.remark-new').hide();
                });


                $(document).on('remark:viewing', function(event, remark_id) {
                    $('.remark-edit').show();
                    $('.remark-new').show();
                });

                $(document).on('remark:new', function(e, remark_id) {

                    var a = $('#remark_' + remark_id);
                    var b = a.closest('.do_remark_widget');

                    var ref = b.data('ui-remark_widget');

                    ref.setValues(remark_id);

                });

                $(document).on('remark:delete', function(e, remark_id) {

                    var widget = $("div[data-remark-id='" + remark_id + "']"),
                        ref = widget.data('ui-remark_widget');
                    ref.afterDelete();

                });


        }

    });
})(jQuery);
