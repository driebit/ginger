$.widget("ui.search_cmp_filters_edge", {

    _create: function() {
        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'edge';
        me.inputs = inputs;

        inputs.on('change', function () {
            $(document).trigger('search:inputChanged');
            me.inputChanged = true;
        });
    },

    getValues: function() {
        var inputs = this.widgetElement.find('input:checked'),
            values = $.map(inputs, function(input) {
                return $(input).val();
            });

        return [{
            'type': this.type,
            'values': values
        }];
    },

    setValues: function(values) {
        var widgetValues;

        try {
           widgetValues = values[this.type];
        } catch(e) {}

        if (widgetValues && widgetValues.length > 0) {
            $.each(this.inputs, function(i, input) {
                if ($.inArray($(input).val(), widgetValues) !== -1) {
                    $(input).attr('checked', 'checked');
                }
            });
        }
    }
});
