(function($) {
    'use strict';

    $.widget('ui.ginger_default_article_foldout', {
        options: {
            collapsedClass: 'collapsed'
        },
        _create: function() {
            var me = this,
                element = $(me.element),
                button = element.find('.btn-article-foldout'),
                elementHeight = element.height(),
                commentsHeight = element.find('.page__content__comments__wrapper').height();

            button.on('click', function (evt) {
                me.toggle();

                evt.preventDefault();
            });

            $('[href=#comments]').on('click', function () {
                me.expand();
            });

            if (elementHeight - commentsHeight > 300) {
                me.collapse();
            }
        },

        toggle: function () {
            this.element.toggleClass(this.options.collapsedClass);
        },

        collapse: function () {
            this.element.addClass(this.options.collapsedClass);
        },

        expand: function () {
            this.element.removeClass(this.options.collapsedClass);
        }
    });
})(jQuery);
