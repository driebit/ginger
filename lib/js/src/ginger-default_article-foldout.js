(function($) {
    'use strict';

    $.widget('ui.ginger_default_article_foldout', {
        _create: function() {
            var me = this,
                element = $(me.element),
                button = element.find('.btn-article-foldout'),
                collapsedClass = 'collapsed',
                elementHeight = element.height(),
                commentsHeight = element.find('.page__content__comments__wrapper').height();

            button.on('click', function() {

                element.removeClass(collapsedClass);
                return false;
            });

            if (elementHeight - commentsHeight > 300) {
                element.addClass(collapsedClass);
            }
        }
    });
})(jQuery);
