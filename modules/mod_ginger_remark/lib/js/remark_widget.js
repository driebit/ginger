(function ($) {
   'use strict';

    $.widget( "ui.remark_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);

            me.editing = true;
            me.tinymce_name = widgetElement.data('tinyname');


                $('.remarks').on('click', '.remark-edit', function() {

                    // if (!me.editing) {
                    //     $.proxy(me.enableEdit(), me);
                    // } else {
                    //     $.proxy(me.disableEdit(), me);
                    // }


                    z_event('testrefresh');


                    return false;
                });




                //tinymce.EditorManager.execCommand('mceToggleEditor', true, 'rsc-aap');


                //widgetElement.append('<textarea id="rsc-aap" class="aap z_editor-init form-control"  %}></textarea>');



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
