$.widget("ui.search_cmp_filters_period", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'period';
        me.property = widgetElement.data('property');

        inputs.on('change', function () {
            $(document).trigger('search:inputChanged');
        });
    },

    getValues: function() {
        return [{
            'type': this.type,
            'values': {
                'min': $(this.widgetElement.find('[name*="min"]')[0]).val(),
                'max': $(this.widgetElement.find('[name*="max"]')[0]).val()
            }
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
    },

    getFacets: function(facets) {
        facets.period_min = {
            'field': this.property
        };
        facets.period_max = {
            'field': this.property
        };

        return facets;
    }
});
