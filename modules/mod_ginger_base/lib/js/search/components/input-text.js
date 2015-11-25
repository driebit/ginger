$.widget("ui.search_cmp_input_text", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;

        me.widgetElement.keypress(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                $(document).trigger('search:inputChanged');
            }
        });

        if($.url().param('qs') != '') {
            me.widgetElement.val($.url().param('qs'));
        }

    },

    getValues: function() {

        var me = this;
        return [{
            'type': 'qs',
            'values': me.widgetElement.val()
        }]
    }

});
