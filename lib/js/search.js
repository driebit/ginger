(function ($) {
   'use strict';

    $.widget("ui.search", {
        _init: function() {
            this.init();
        },

        init: function() {

            var self = this,
                element = self.element,
                timer = null,
                prevVal = null,
                paramResults = element.data('param-results'),
                paramContainer = element.data('param-container'),
                paramWire = element.data('param-wire'),
                resultsElement = $("#" + paramResults),
                windowHeight = $(window).height();

            resultsElement.hide();
            resultsElement.removeClass('is-scrolable');

            function doSearch() {

                var val = self.element.val();

                if (!val.length) {
                    resultsElement.hide();
                    return;
                }

                if (prevVal && val == prevVal || !val.length) {
                    return;
                }

                prevVal = val;
                z_event(paramWire, {value: val});

                resultsElement.show(function(){
                    if (resultsElement.height() > windowHeight) {
                        resultsElement.addClass('is-scrollable');
                    }
                });
            }

            self.element.on('keyup', function() {
                if (timer) {
                    clearTimeout(timer);
                }

                timer = setTimeout(doSearch, 300);
            });

            $(document).mouseup(function (e) {

                var container = $("#" + paramContainer),
                    closest = $(e.target).closest(container);

                    console.log(closest.size());

                 if (!container.is(e.target) // if the target of the click isn't the container...
                     && closest.size() == 0)
                 {
                    resultsElement.hide();
                 }
            });
        }
    });
})(jQuery);
