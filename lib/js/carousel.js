
$.widget( "ui.carousel", {

    _create: function() {

         var me = this,
             widgetElement = $(me.element),
             id = widgetElement.attr('id'),
             slick = null;

        if (this.options){
            $(widgetElement).slick(this.options);
        } else {
            $(widgetElement).slick();
        }

        $('.carousel__pager__item__link[data-carousel-id="' + id + '"]').click(function() {
            $(widgetElement).slick('slickGoTo', parseInt($(this).data('slide-index')));
            return false;
        });

        $(widgetElement).on('afterChange', function(event, slick, currentSlide){
             
             $('.carousel__pager__item__link[data-carousel-id="' + id + '"]').removeClass('active');
             $('.carousel__pager__item__link[data-carousel-id="' + id + '"][data-slide-index="' + currentSlide + '"]').addClass('active');

        });

    }

});

