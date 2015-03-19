(function ($) {
    'use strict';

    $.widget('ui.ginger_default_toggle_search', {
        _create: function () {
            var me        = this,
                element   = me.element,
                toggleBtn = element.find('.main-nav__toggle-search a'),
                closeBtn  = element.find('.main-nav__close-search-btn');

            toggleBtn.on('click', function (evt) {
                evt.preventDefault();

                me._showSearch();
            });

            closeBtn.on('click', function () {
                me._hideSearch();
            });

            $(document).on('click', function (evt) {
                var target = $(evt.target);

                if ((target.parents('.main-nav__search').length === 0 && !target.parent().hasClass('main-nav__toggle-search')) || target.hasClass('main-nav__search__close-btn'))  {
                    me._hideSearch();
                }
            });
        },

        _showSearch: function () {
            this.element.find('.main-nav__search').addClass('is-shown');
        },

        _hideSearch: function () {
            this.element.find('.main-nav__search').removeClass('is-shown');
        }
    });
})(jQuery);
