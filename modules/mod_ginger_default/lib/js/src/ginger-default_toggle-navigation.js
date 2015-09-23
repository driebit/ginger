(function ($) {
    'use strict';

    $.widget('ui.ginger_default_toggle_navigation', {
        _create: function () {
            var me        = this,
                toggleBtn = me.element.find('.main-nav__toggle-menu a');

            toggleBtn.on('click', function (evt) {
                evt.preventDefault();

                me._toggleOffCanvas();
            });

            $(document).on('click', function (evt) {
                var target = $(evt.target);

                if (target.parent().hasClass('main-nav__toggle-menu').length === 0 && target.parents('main-nav__off-canvas').length === 0) {
                    me._hideOffCanvas();
                }
            });
        },

        _hideOffCanvas: function () {
            this.element.find('.main-nav__off-canvas').removeClass('is-shown');
        },

        _toggleOffCanvas: function () {
            this.element.find('.main-nav__off-canvas').toggleClass('is-shown');
        }
    });
})(jQuery);
