(function($) {
    'use strict';

    $.widget("ui.masthead_map", {

        _init: function() {
            this.init();
        },

        init: function() {
            var me = this,
                element = me.element;

            element.on('click', function(){
            	element.addClass('is-active');
            });

        }

    });
})(jQuery);
