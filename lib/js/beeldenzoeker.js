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
        'autoSize': false,
        'autoScale': false,
        'margin': 20,
        'autoCenter': true,
        'width': '100vw',
        'height': '100vh',
        'autoResize': true,
        'fitToView': false,
        'scrolling': false,
        "padding": 0,
        'tpl': {
                error: '<p class="fancybox-error"></p>'
        },
        'helpers': {
            'title': {
                type: 'inside'
            },
            'overlay': {
                'css': {
                    'background': 'rgba(76, 76, 76, 0.95)'
                },
                locked: false
            },
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