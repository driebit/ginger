$.widget("ui.carousel", {

    _create: function () {

        var me = this,
            widgetElement = $(me.element),
            id = widgetElement.attr('id'),
            options = this.options;

        if (options) {
            $(widgetElement).slick(options);
        } else {
            $(widgetElement).slick();
        }
    }

});
