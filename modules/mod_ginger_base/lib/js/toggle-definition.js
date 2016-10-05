(function($) {
    'use strict';

    $.widget("ui.toggledefinition", {

        _init: function() {

            var me = this,
                element = $(me.element);

            me.element = element;

            element.on('click', function() {

                var content = me.element.attr('title');

                me.element.toggleClass('show');

                if (me.element.hasClass('show')) {

                    var abbr = $('<span class="toggle-content">' + content + '</span>');
                    me.abbr = abbr;
                    me.element.after(abbr);

                } else {
                    me.abbr.remove();
                }

                return false;

            });

        }

    });

})(jQuery);
