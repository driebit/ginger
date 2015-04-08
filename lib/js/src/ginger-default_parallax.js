(function ($) {
    'use strict';

    $.widget('ui.ginger_default_paralax', {
        _create: function () {
            var me               = this,
                element          = me.element,
                id,
                timeoutId;

            jQuery(window).on('scroll', function () {
                setAnim();

                window.clearTimeout(timeoutId);

                timeoutId = window.setTimeout(function () {
                    window.webkitCancelAnimationFrame(id);
                });
            });

            function setAnim () {
                id = window.webkitRequestAnimationFrame(function () {
                    element.css({
                        'background-position': '0 ' + ( (jQuery(window).scrollTop() / 2)) + 'px'
                    });

                    setAnim();
                });
            }
        }
    });
})(jQuery);
