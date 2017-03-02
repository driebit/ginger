$(document).ready(function(){

	// Carousel
	$('.list-carousel').slick({
		slidesToShow: 3,
		slidesToScroll: 1,
        variableWidth: true
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
            },
        },
        beforeLoad : function() {
	        /* You can use callbacks to customize or disable title */
	        this.title = false; 
	    },
        afterShow: function() {
            $('.fancybox-image')
            .wrap('<span style="display:inline-block"></span>')
            .css('display', 'block')
            .parent()
            .zoom({
                magnify: 1.25,
                on:'click'
            });
        }
    });
});

$(window).scroll(function(){
    var buttonMore = $('#more-results'),
        scrollOffset = $(window).scrollTop(),
        windowHeight = $(window).height();

    console.log(buttonMore.offset().top);
     if ((scrollOffset + windowHeight) >= buttonMore.offset().top ){
        z_event("moreresults");
     }
});