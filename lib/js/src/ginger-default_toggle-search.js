(function ($) {
    'use strict';

    $.widget('ui.ginger_default_toggle_search', {
        _create: function () {
            var me        = this,
                element   = me.element,
                toggleBtn = element.find('.main-nav__toggle-search a'),
                closeBtn  = element.find('.main-nav__search-form__close-btn');

            toggleBtn.on('click', function (evt) {
                evt.preventDefault();

                me._showSearch();
            });

            closeBtn.on('click', function () {
                me._hideSearch();
            });

            $(document).on('click', function (evt) {
                var target = $(evt.target);

                if (target.parents('.main-nav__search-form').length === 0 || target.hasClass('.main-nav__search-form__close-btn')) {
                    if (target.parent().hasClass('main-nav__toggle-search').length === 0) {
                        me._hideSearch();
                    }
                }
            });
        },

        _showSearch: function () {
            this.element.find('.main-nav__search-form').addClass('is-shown');
        },

        _hideSearch: function () {
            this.element.find('.main-nav__search-form').removeClass('is-shown');
        }
    });
})(jQuery);
