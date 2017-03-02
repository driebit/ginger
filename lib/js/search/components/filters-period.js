$.widget("ui.search_cmp_filters_period", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'period';
        me.property = widgetElement.data('property');
        me.inputs = inputs;
        me.inputChanged = false;

        inputs.on('change', function () {
            $(document).trigger('search:inputChanged');
            me.inputChanged = true;
        });
    },

    getValues: function() {
        return [{
            'type': this.type,
            'values': {
                'min': $(this.inputs[0]).val(),
                'max': $(this.inputs[1]).val()
            }
        }]
    },

    setValues: function(values) {
        var me = this,
            widgetValues;

        try {
           widgetValues = values[me.type];
        } catch(e) {}

        $(this.inputs[0]).val(widgetValues.min);
        $(this.inputs[1]).val(widgetValues.max);
    },

    getFacets: function(facets) {
        facets.period_min = {
            'min': {
                'field': this.property,
                'format': 'YYYY'
            }
        };
        facets.period_max = {
            'max': {
                'field': this.property,
                'format': 'YYYY'
            }
        };

        return facets;
    },

    setFacets: function(facets) {
        // Don't set facets if this filter was the source of the search query.
        if (this.inputChanged) {
            this.inputChanged = false;

            return;
        }


        if (facets.period_min && facets.period_min.value !== 0) {
            var minDate = new Date(facets.period_min.value);
            $(this.inputs[0]).val(minDate.getFullYear());
        }

        if (facets.period_max && facets.period_max.value !== 0) {
            var maxDate = new Date(facets.period_max.value);
            $(this.inputs[1]).val(maxDate.getFullYear());
        }
    }
});
