(function($) {
    'use strict';

    $.widget('ui.ginger_default_content_group_navigation', {

        _create: function() {

            var me = this,
                element = me.element,
                banner = $('.content-groups-nav__banner');

            if (banner.size() > 0) {
                element.addClass('has-content-group-banner');
            };

            banner.on('click', $.proxy(me._scrollToTop, me));
        },

        _scrollToTop: function() {

            $("html, body").animate({
                scrollTop: 0
            }, "slow");
            return false;
        }

    });
})(jQuery);
