$.widget("ui.carousel", {

    _create: function () {
        var me = this,
            widgetElement = $(me.element),
            id = widgetElement.attr('id'),
            options = {dots: true, autoplay: true};

            // options = this.options; // old code

            if (widgetElement.data('carousel-options')) {
                options =  widgetElement.data('carousel-options');
            }
        if (options) {
            $(widgetElement).slick(options);
        } else {
            $(widgetElement).slick();
        }
    }

});
