(function ($) {
   'use strict';

    $.widget( "ui.remark_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);

                me.widgetElement = widgetElement;

                widgetElement.on('click', '.remark-cancel', function() {
                    var editing = me.widgetElement.data('editing');
                    $.proxy(me.switchToView(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-edit', function() {
                    var editing = me.widgetElement.data('editing');
                    $.proxy(me.switchToEdit(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-save', function() {
                    $.proxy(me.save(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-delete', function() {
                    $.proxy(me.delete(), me);
                    return false;
                });


        },

        // closeAll: function() {
        //
        //     var me = this,
        //         widgetEls = $("[class*='do_remark_widget']"),
        //         widgetRefs = []
        //
        //      $.each(widgetEls, function(i, element) {
        //
        //         var classnames = element.className.split(/\s+/),
        //             element = $(element);
        //
        //         $.each(classnames, function(j, classname) {
        //             if (classname.match(/do_remark_widget/)) {
        //                 var widgetName = classname.replace(/^do_/, '');
        //                  widgetRefs.push(element.data('ui-' + widgetName));
        //             }
        //         });
        //      });
        //
        //      $.each(widgetRefs, function(i, widget) {
        //          widget.switchToView();
        //      });
        //
        // },

        switchToEdit: function() {

            var me = this,
                remark_id = me.widgetElement.data('remark-id'),
                id = me.widgetElement.data('id'),
                unique = me.widgetElement.data('unique');

            me.widgetElement.data('editing', 1);

            z_event('render_remark_'+unique, {'editing':1, 'remark_id': remark_id, 'id': id});

            return false;

        },

        switchToView: function() {

            var me = this,
                remark_id = me.widgetElement.data('remark-id'),
                id = me.widgetElement.data('id'),
                unique = me.widgetElement.data('unique');

            me.widgetElement.data('editing', '0');

            z_event('render_remark_' + unique, {'editing':0, 'remark_id': remark_id, 'id': id });

            return false;

        },

        setValues(remark_id) {

            var me = this;

            if (remark_id) {
                me.widgetElement.data('remark-id', remark_id);
            }

        },

        isEditing: function() {
            //TODO
        },

        save: function() {

            //TODO: validations

            var me = this,
                form = me.widgetElement.find('#rscform');

            $(form).submit();

            //TODO: wait for server response before switching back
            me.switchToView();

            return false;

        },

        delete: function() {

            var me = this,
                remark_id = me.widgetElement.data('remark-id');

            z_event('rsc_delete_' + remark_id);
        },

        afterDelete: function() {

            var me = this;

            delete z_registered_events['rsc_delete_' + me.widgetElement.data('remark-id')];
            delete z_registered_events['render_remark_' + me.widgetElement.data('unique')];

            if (me.widgetElement) me.widgetElement.remove();

        }

    });
})(jQuery);
