(function($) {
    'use strict';

    $.widget('ui.article_foldout', {
        options: {
            collapsedClass: 'collapsed',
            cutoff: 300
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

            if (elementHeight - commentsHeight > me.options.cutoff) {
                me.collapse();
            }
        },

        toggle: function () {
            var me = this,
                element = me.element,
                collapsedClass = me.options.collapsedClass;

            element.toggleClass(collapsedClass);

            if (element.hasClass(collapsedClass)) {
                window.scrollTo(0,0);
            }
        },

        collapse: function () {
            this.element.addClass(this.options.collapsedClass);
        },

        expand: function () {
            this.element.removeClass(this.options.collapsedClass);
        }
    });
})(jQuery);
