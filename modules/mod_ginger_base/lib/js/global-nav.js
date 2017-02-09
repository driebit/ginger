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

            me.menuButton.on('click', me._toggleMenu.bind(me));
            me.document.on('click', me._closeMenu.bind(me));

            me.document.on('menu:close', me._closeMenu.bind(me));

            if ('ontouchstart' in document.documentElement) {
                if ($('.global-nav__menu__dropdown').length > 0) {
                    var openLink = false;
                    $('body').prepend('<div class="global-nav__menu__dropdown_close"> </div>');
                    $('.global-nav__menu__dropdown_close').on('touchstart', function(e) {
                        $('.global-nav__menu__dropdown').removeClass('touch-open');
                        $(this).hide();
                        openLink = false;
                    });
                    $('.global-nav__menu__dropdown').each(function(i) {
                        $(this).find('a:first').on('touchstart', function(e) {
                            if (openLink == false) {
                                e.preventDefault();
                                $(this).parent().addClass('touch-open');
                                $('.global-nav__menu__dropdown_close').show();
                                openLink = true;
                            } else {
                                if ($(this).parent().hasClass('touch-open') == false) {
                                    $('.global-nav__menu__dropdown').removeClass('touch-open');
                                    e.preventDefault();
                                    $(this).parent().addClass('touch-open');
                                }
                            }
                        });
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
