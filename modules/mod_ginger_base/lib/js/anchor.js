(function($) {
    'use strict';

    $.widget('ui.anchor', {
        _create: function() {
            var me = this,
                element = $(me.element),
                anchor = element.attr('href'),
                offset = 0;

            if (element.data('offset')) {
                offset = element.data('offset');
            }

            element.on('click', function (evt) {
                evt.preventDefault();

                $('html, body').animate({
                    scrollTop: ($(anchor).offset().top - offset)
                }, 1000);
            });
        }
    });
})(jQuery);
