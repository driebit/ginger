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

            if ('ontouchstart' in document.documentElement) {
              if ($('.global-nav__menu__dropdown').length > 0) {
                    var openLink = false;
                    $('.global-nav__menu__dropdown').each(function() {
                        var toplink = $(this).find('a:first').clone();
                        var dropdown = $(this).find('ul');
                        var dropdownfirst = $(this).find('ul li:first');
                        dropdownfirst.clone().prependTo(dropdown).html(toplink);
                    });
                    $('.global-nav__menu__dropdown a:first').on('click touchstart', function(e) {
                        e.preventDefault();
                        $(this).parent().toggleClass('touch-open');
                    });
                }
            }
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
