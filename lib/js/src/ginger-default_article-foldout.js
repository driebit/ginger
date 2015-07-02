(function($) {
    'use strict';

    $.widget('ui.ginger_default_article_foldout', {

        _create: function() {

            var me = this,
                element = $(me.element),
                button = element.find('.btn-article-foldout');

            button.on('click', function() {
                element.removeClass('collapsed');
                return false;

            });

            if(element.height() > 575) {
                element.addClass('collapsed');
            }

        }

    });
})(jQuery);
