$.widget("ui.search_cmp_filters_categories", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'cat';

        inputs.on('change', function() {
            $(document).trigger('search:inputChanged');
        });

    },

    getValues: function() {

        var me = this,
            inputs = me.widgetElement.find('input:checked'),
            values;

        values = $.map(inputs, function(input) {
            return $(input).val();
        });

        //must return an array of objects
        return [{
            'type': me.type,
            'values': values
        }]
    },

    setValues: function(values) {

        var me = this,
            widgetValues,
            inputs = me.widgetElement.find('input');

        try {
           widgetValues = values[me.type];
        } catch(e) {}


        //reset
        $.each(inputs, function(i, input) {
            $(input).removeAttr('checked');
        });

        if (widgetValues && widgetValues.length > 0) {

            $.each(inputs, function(i, input) {
                if ($.inArray($(input).val(), widgetValues) != -1) {
                    $(input).attr('checked', 'checked');
                }
            });
        }


    }

});
