$.widget("ui.carousel", {

    _create: function () {
        function MergeRecursive(obj1, obj2) {
            for (var p in obj2) {
                try {
                    // Property in destination object set; update its value.
                    if ( obj2[p].constructor==Object ) {
                        obj1[p] = MergeRecursive(obj1[p], obj2[p]);
                    } else {
                        obj1[p] = obj2[p];
                    }
                } catch(e) {
                    // Property in destination object not set; create it and set its value.
                    obj1[p] = obj2[p];
                }
            }
            return obj1;
        }

        var me = this,
            widgetElement = $(me.element),
            id = widgetElement.attr('id'),
            settings = this.options;  // Is this used?

        settings = MergeRecursive(settings, {dots: true, autoplay: true}); // this would be default behavior

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
