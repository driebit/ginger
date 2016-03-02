(function($) {
    'use strict';

    $.widget('ui.expand', {
        _create: function() {
            var me = this,
                element = $(me.element),
                type = element.data('type'),
                parentAll = '.' + element.data('parent'),
                parent = '#' + element.data('parent'),
                contentAll = '.' + element.data('content'),
                contentId = '#' + element.data('content');

            if (type == 'all') {
                element.on('click', function (evt) {
                    evt.preventDefault();

                    if (element.hasClass('is-open')) {
                        element.removeClass('is-open');
                        $(parentAll).removeClass('is-open');
                        $(contentAll).slideUp();

                        $(document).trigger('foldout:collapse');
                    } else {
                        element.addClass('is-open');
                        $(parentAll).addClass('is-open');
                        $(contentAll).slideDown();

                        $(document).trigger('foldout:expand');
                    }
                });

            } else {
                element.on('click', function (evt) {
                    evt.preventDefault();

                    $(parent).toggleClass('is-open');
                    $(element).toggleClass('is-open');
                    $(contentId).slideToggle();
                });
            }
        }
    });
})(jQuery);
