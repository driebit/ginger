(function($) {
    'use strict';

    $.widget('ui.foldout', {
        options: {
            collapsedClass: 'is-collapsed',
            expandedClass: 'is-expanded',
            cutoff: 700
        },

        _create: function() {

            var me = this,
                element = $(me.element),
                button = element.find('.foldout__button'),
                elementHeight = element.height(),
                commentsHeight = element.find('.comments').height();

            if (element.data('height')) {
                me.options.cutoff = element.data('height');
            }

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

            $(document).on('foldout:expand', $.proxy(me.expand, me));
            $(document).on('foldout:collapse', $.proxy(me.collapse, me));
        },

        toggle: function () {

            var me = this,
                element = me.element,
                collapsedClass = me.options.collapsedClass;

            if (element.hasClass(collapsedClass)) {
                me.expand();
            } else {
                me.collapse();
                $('html,body').animate({scrollTop:0}, 800);
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
