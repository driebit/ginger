(function ($) {
    'use strict';

    $.widget('ui.ginger_default_scroll_top', {
        _create: function () {
            var me        = this,
                element   = me.element;

            element.on('click', function (evt) {
                evt.preventDefault();

                $('html, body').animate({scrollTop : 0},800);
            });
        }
    });
})(jQuery);
