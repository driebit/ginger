$.widget("ui.search_cmp_input_text", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.type = 'qs';

        me.widgetElement.keypress(function(event) {
            if (event.keyCode == 13) {
                event.preventDefault();
                $(document).trigger('search:inputChanged');
            }
        });
    },

    getValues: function() {

        var me = this;

        return [{
            'type': me.type,
            'values': me.widgetElement.val()
        }]
    },


    setValues: function(values) {

        var me = this,
            widgetValues = values[me.type];

        me.widgetElement.val('');

        if (widgetValues) {
            me.widgetElement.val(widgetValues);
        }
    }

});
