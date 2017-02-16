$(document).ready(function(){

	// Carousel
	$('.list-carousel').slick({
		infinite: true,
		slidesToShow: 3,
		slidesToScroll: 2,
		responsive: [
		    {
		      breakpoint: 1024,
		      settings: {
		        slidesToShow: 3,
		        slidesToScroll: 3,
		        infinite: true,
		      }
		    },
		    {
		      breakpoint: 800,
		      settings: {
		        slidesToShow: 2,
		        slidesToScroll: 2,
		        infinite: true,
		      }
		    },
		    {
		      breakpoint: 600,
		      settings: {
		        slidesToShow: 1,
		        slidesToScroll: 1,
		        infinite: true
		      }
		    }
		]
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