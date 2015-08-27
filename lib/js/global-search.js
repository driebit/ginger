(function ($) {
   'use strict';

    $.widget("ui.global_search", {
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

            hideAndClear();
            resultsElement.removeClass('is-scrolable');

            function doSearch() {

                var val = self.element.val();

                if (!val.length) {
                    // hideAndClear();
                    return;
                }

                if (prevVal && val == prevVal || !val.length) {
                    return;
                }

                prevVal = val;
                z_event(paramWire, {value: val});

                resultsElement.show(function(){
                    if (resultsElement.outerHeight() > windowHeight) {
                        resultsElement.addClass('is-scrollable');
                    }
                });
            }


            self.element.on('keyup', function(e) {

                if(e.keyCode == 27) {
                   $(document).trigger("search:close");
                } else {
                    if (timer) clearTimeout(timer);
                    timer = setTimeout(doSearch, 300);
                }

            });


            $(document).mouseup(function (e) {

                var container = $("#" + paramContainer),
                    closest = $(e.target).closest(container);

                 if (!container.is(e.target) // if the target of the click isn't the container...
                     && closest.size() == 0)
                 {
                    $(document).trigger("search:close");
                 }
            });


        }


    });
})(jQuery);
