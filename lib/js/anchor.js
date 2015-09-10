(function($) {
    'use strict';

    $.widget('ui.anchor', {
        _create: function() {

            //TODO: inlcude & TEST

            var me = this,
                element = $(me.element),
                anchor = element.attr('id');

            element.on('click', function (evt) {
                evt.preventDefault();

                $('html, body').animate({
                    scrollTop: anchor.offset().top
                }, 1000);
            });
        }
    });
})(jQuery);
