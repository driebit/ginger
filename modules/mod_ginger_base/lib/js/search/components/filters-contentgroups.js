$.widget("ui.search_cmp_filters_contentgroups", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'content_group';

        inputs.on('click', function() {
            $(document).trigger('search:inputChanged');
        });
    },

    getValues: function() {

        var me = this,
            inputs = me.widgetElement.find('input:checked'),
            values;

        values = $.map(inputs, function(input) {
            return parseInt($(input).val());
        });

        //must return an array of objects
        return [{
            'type': me.type,
            'values': values[0]
        }]
    },

    setValues: function(values) {

        var me = this,
            widgetValues,
            inputs = me.widgetElement.find('input');
        try {
           widgetValue = values[me.type];
        } catch(e) {}

        $.each(inputs, function(i, input) {
            $(input).removeAttr('checked');
        });
        
        if (widgetValue) {
            $.each(inputs, function(i, input) {
                if ($(input).val() == widgetValue) {
                    $(input).attr('checked', 'checked');
                }
            });
        }
        
    }

});
