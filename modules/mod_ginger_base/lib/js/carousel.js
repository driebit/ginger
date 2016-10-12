$.widget("ui.carousel", {

    _create: function () {
        var me = this,
            widgetElement = $(me.element),
            id = widgetElement.attr('id'),
            options = {dots: true, autoplay: true}
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
