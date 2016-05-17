(function ($) {
   'use strict';

    $.widget( "ui.remarks_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);


                //$('.remarks').css('border', '3px solid blue');

                $('.remarks').on('click', '.new', function() {

                    // z_event('aapnew');
                    //
                    // var a = setTimeout(function() {
                    //     z_editor.init();
                    // }, 1000);

                    return false;
                });

                $('.remarks').on('click', '.testsave', function() {

                    var form = $(this).closest('form').submit();
                    // z_event('aapnew');
                    //
                    // var a = setTimeout(function() {
                    //     z_editor.init();
                    // }, 1000);

                    return false;
                });

                $(document).on('aap', function() {
                    //z_editor.init();
                    //alert('aap');
                });


        }







    });
})(jQuery);
