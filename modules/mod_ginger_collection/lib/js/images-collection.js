$(document).ready(function () {

    // Carousel
    $('.list-carousel').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        variableWidth: true,
        centerMode: true,
        useCSS: true
    });

    $(".fancybox").fancybox();

    $(".masthead__zoom").fancybox({
        'openEffect': "fade",
        'margin': 20,
        'autoCenter': true,
        'autoResize': true,
        'scrolling': false,
        "padding": 0,
        'type': 'image',
        'clickContent': false,
        'tpl': {
            error: '<p class="fancybox-error"></p>'
        },
        'helpers': {
            'title': {
                type: null
            },
            'overlay': {
                'css': {
                    'background': 'rgba(76, 76, 76, 0.95)'
                },
                locked: false
            }
        },
        beforeLoad: function () {
            /* You can use callbacks to customize or disable title */
            this.title = false;
        },
        afterShow: function () {
            $('.fancybox-inner').prepend('<div class="zoom-help"></div>');

            $('.fancybox-image')
                .parent()
                .zoom({
                    magnify: 1.25,
                    on: 'click'
                });
        }
    });
});
