(function ($) {
    'use strict';

    var normalizedRequestAnimationFrame,
        normalizedCancelAnimationFrame;

    (function () {
        var requestPrefixes = ['webkitR', 'mozR', 'msR', 'oR', 'r'],
            cancelPrefixes = ['webkitC', 'mozC', 'msC', 'oC', 'c'],
            functionName,
            i;

        for (i=0; i<requestPrefixes.length; i++) {
            functionName = requestPrefixes[i] + 'equestAnimationFrame';

            if (functionName in window) {
                normalizedRequestAnimationFrame = window[functionName];
                normalizedCancelAnimationFrame = window[cancelPrefixes[i] + 'ancelAnimationFrame'];
            }
        }

        if (!normalizedRequestAnimationFrame) {
            normalizedRequestAnimationFrame = function (callback) {
                return window.setTimeout(callback, 1000/60);
            };

            normalizedCancelAnimationFrame = function (timeoutId) {
                window.clearTimeout(timeoutId);
            };
        }
    })();

    $.widget('ui.parallax', {
        _create: function () {
            var me               = this,
                element          = me.element,
                id,
                timeoutId;

            jQuery(window).on('scroll', function () {
                setAnim();

                window.clearTimeout(timeoutId);

                timeoutId = window.setTimeout(function () {
                    normalizedCancelAnimationFrame(id);
                });
            });

            function setAnim () {
                id = normalizedRequestAnimationFrame(function () {
                    element.css({
                        'background-position': 'center ' + ( (jQuery(window).scrollTop() / 2)) + 'px'
                    });

                    setAnim();
                });
            }
        }
    });
})(jQuery);
