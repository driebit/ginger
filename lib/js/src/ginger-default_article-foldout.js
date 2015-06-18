(function($) {
    'use strict';

    $.widget('ui.ginger_default_article_foldout', {

        _create: function() {

            var me = this,
                element = $(me.element),
                button = element.find('.btn-article-foldout');

            button.on('click', function() {
                element.removeClass('collapsed');
                $(this).hide();
                return false;

            });

            if(element.height() > 475) {
                element.addClass('collapsed');
                button.css({'display':'block'});
            }

        }

    });
})(jQuery);
