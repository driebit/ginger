
(function ($) {
   'use strict';

    $.widget("ui.ginger_search", {
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

            resultsElement.css('visibility', 'hidden');

            function doSearch() {

                var val = self.element.val();

                if (!val.length) {
                    resultsElement.css('visibility', 'hidden');
                    return;
                }

                if (prevVal && val == prevVal || !val.length) {
                    return;
                }

                prevVal = val;
                z_event(paramWire, {value: val});

                resultsElement.removeClass('is-scrolable');

                setTimeout(function(){
                    //TODO: This should happen in the complete of the wire

                    if ((resultsElement.outerHeight() +  65) > windowHeight) {
                        resultsElement.addClass('is-scrolable');
                        resultsElement.css('visibility', 'visible');
                    } else {
                        resultsElement.css('visibility', 'visible');
                    }
                }, 300);
            }

            self.element.on('keyup', function() {
                if (timer) {
                    clearTimeout(timer);
                    timer = null;
                }

                timer = setTimeout(doSearch, 500);
            });

            $(document).mouseup(function (e) {

                var container = $("#" + paramContainer),
                    closest = $(e.target).closest(container);

                 if (!container.is(e.target) // if the target of the click isn't the container...
                     && closest.size() == 0)
                 {
                    $('.ginger-search').removeClass('is-visible');

                    resultsElement.css('visibility', 'hidden');
                 }
            });
        }
    });
})(jQuery);
