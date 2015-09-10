(function($) {
    'use strict';

    $.widget('ui.foldout', {
        options: {
            collapsedClass: 'is-collapsed',
            expandedClass: 'is-expanded',
            cutoff: 500
        },
        _create: function() {

            var me = this,
                element = $(me.element),
                button = element.find('.foldout__button'),
                elementHeight = element.height(),
                commentsHeight = element.find('.comments').height();

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
            this.element.removeClass(this.options.expandedClass);
            this.element.addClass(this.options.collapsedClass);
        },

        expand: function () {
            this.element.addClass(this.options.expandedClass);
            this.element.removeClass(this.options.collapsedClass);
        }
    });
})(jQuery);
