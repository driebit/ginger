(function ($) {
    'use strict';

    $(window).scroll(function () {
        var scrollOffset = $(window).scrollTop(),
            windowHeight = $(window).height();

        if (scrollOffset >= windowHeight) {
            $('.back-to-top').css('display', 'block');
        } else {
            $(".back-to-top").css('display', 'none');
        }
    });
})(jQuery);
