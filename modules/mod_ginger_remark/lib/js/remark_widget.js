(function ($) {
   'use strict';

    $.widget( "ui.remark_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);

            me.tinymce_name = widgetElement.data('tinyname');
            me.id = widgetElement.data('id');
            me.widgetElement = widgetElement;

                widgetElement.on('click', '.remark-edit', function() {

                    var editing = me.widgetElement.data('editing');

                    if (me.editing == 1) {
                        $.proxy(me.switchToEdit(), me);
                    } else {
                        $.proxy(me.switchToView(), me);
                    }

                    return false;
                });

                widgetElement.on('click', '.remark-save', function() {
                    $.proxy(me.save(), me);
                    return false;
                });

        },

        closeAll: function() {

            var me = this,
                widgetEls = $("[class*='do_remark_widget']"),
                widgetRefs = []

             $.each(widgetEls, function(i, element) {

                var classnames = element.className.split(/\s+/),
                    element = $(element);

                $.each(classnames, function(j, classname) {
                    if (classname.match(/do_remark_widget/)) {
                        var widgetName = classname.replace(/^do_/, '');
                         widgetRefs.push(element.data('ui-' + widgetName));
                    }
                });
             });

             $.each(widgetRefs, function(i, widget) {
                 widget.switchToView();
             });

        },

        switchToEdit: function() {

            var me = this;

            me.closeAll();

            z_event('render-remark-'+me.id, {'editing':1, 'remark_id': undefined});

            return false;

        },

        switchToView: function() {

            var me = this;

            z_event('render-remark-' + me.id, {'editing':0, 'remark_id': undefined});

            return false;

        },

        isEditing: function() {

            //var me = this;
            //return me.editing;

            //TODO
        },

        save: function() {


            //TODO: validations

            var me = this,
                form = $(me.widgetElement.find('#rscform')[0]);

            console.log(form.serialize());

            form.submit();


            //TODO: do this after saving
            //me.switchToView();


            return false;

        }


        // enableEdit: function() {
        //
        //     var me = this;
        //     var e = tinymce.get(me.tinymce_name);
        //    var c = $(e.container);
        //
        //
        //     e.setMode('design');
        //     c.find('.mce-toolbar-grp').show().end().find('.mce-statusbar').show();
        //     me.editing = true;
        //
        //
        // },
        //
        // disableEdit: function() {
        //
        //     var me = this;
        //     var e = tinymce.get(me.tinymce_name);
        //    var c = $(e.container);
        //
        //     e.setMode('readonly');
        //     c.find('.mce-toolbar-grp').hide().end().find('.mce-statusbar').hide();
        //
        //     me.editing = false;
        //
        // }






    });
})(jQuery);
