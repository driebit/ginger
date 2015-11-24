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

        if($.url().param('search_text') != '') {
            me.widgetElement.val($.url().param('search_text'));
        }

    },

    getValues: function() {

        var me = this;
        return [{
            'type': 'search_text',
            'values': me.widgetElement.val()
        }]
    }

});
