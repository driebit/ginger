(function ($) {
   'use strict';

    $.widget( "ui.remarks_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element),
                showForm = widgetElement.data('show_form');

                widgetElement.on('click', '.remark-new', function() {
                    z_event('new_remark');
                    return false;
                });

                $(document).on('remark:editing', function(event, remark_id) {
                    $('.remark-edit').hide();
                    $('.remark-delete').hide();
                    $('.remark-new').hide();
                });


                $(document).on('remark:viewing', function(event, remark_id) {
                    $('.remark-edit').show();
                    $('.remark-delete').show();
                    $('.remark-new').show();
                });

                $(document).on('remark:new', function(e, remark_id) {
                    var el = $('#remark_' + remark_id).closest('.do_remark_widget'),
                        widget = el.data('ui-remark_widget');

                    widget.setValues(remark_id);
                });

                $(document).on('remark:deleted', function(e, remark_id) {
                    var widget = me.getWidget(remark_id);

                    widget.afterDelete();
                });

                $(document).on('depiction:deleted', function(e, depiction_id, remark_id) {
                     var widget = me.getWidget(remark_id);

                     widget.afterDepictionDelete(depiction_id);
                });

                $(document).on('remark:saved', function(e, remark_id) {
                    var widget = me.getWidget(remark_id);

                    widget.afterSave();
                    if(showForm === true){
                        z_event('new_remark');
                    }

                });

        },

        getWidget: function(remark_id) {

            var els = $("[data-remarkid]"),
                foundEl,
                ref;

            $.each(els, function(i, el) {

                var $el = $(el);
                var dataid = $el.data('remarkid');

                if (dataid == remark_id) {
                    foundEl = $el;
                }

            });

            if (foundEl) {
                ref = foundEl.data('ui-remark_widget');
            }

            return ref;
        }


    });
})(jQuery);
