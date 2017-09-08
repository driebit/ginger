$.widget("ui.carousel", {

    _create: function () {
        function MergeRecursive(defaultSettings, currentSettings) {
            for (var p in currentSettings) {
                try {
                    // Property in destination object set; update its value.
                    if ( currentSettings[p].constructor==Object ) {
                        defaultSettings[p] = MergeRecursive(defaultSettings[p], currentSettings[p]);
                    } else {
                        defaultSettings[p] = currentSettings[p];
                    }
                } catch(e) {
                    // Property in destination object not set; create it and set its value.
                    defaultSettings[p] = currentSettings[p];
                }
            }
            return defaultSettings;
        }

        var me = this,
            widgetElement = $(me.element),
            id = widgetElement.attr('id'),
            settings = this.options;  // Is this used?

        settings = MergeRecursive({dots: true, autoplay: true}, settings); // this would be default behavior

        if (widgetElement.data('carousel-options')) {
            var options =  widgetElement.data('carousel-options');
            settings = MergeRecursive(settings, options);
        }

        if (settings) {
            $(widgetElement).slick(settings);
        } else {
            $(widgetElement).slick();
        }
    }
});
