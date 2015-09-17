(function ($) {
   'use strict';

    $.widget( "ui.global_nav", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this;

            me.document            = $(document),
            me.body                = $('body:eq(0)'),
            me.menuButton          = $(me.element.find('#toggle-menu')[0]);

            me.menuButton.on('click', $.proxy(me._toggleMenu, me));

            $(document).on('menu:close', $.proxy(me._closeMenu, me));

        },

        _closeMenu: function(event) {
            var me = this;
            me._toggleMenu(event, true);
        },

        _toggleMenu: function(event, close) {

            var me = this;

            me.menuButton.toggleClass('is-active');

            if (close) {
                me.body.removeClass('is-menu-visible');
                me.element.removeClass('is-open');
                me.menuButton.removeClass('is-active');
            } else {
                if(me.menuButton.hasClass('is-active')) {
                    me.element.addClass('is-open');
                    me.body.addClass('is-menu-visible');
                } else {
                    me.element.removeClass('is-open');
                    me.body.removeClass('is-menu-visible');
                }
            }

            return false;

        }
    });

})(jQuery);
