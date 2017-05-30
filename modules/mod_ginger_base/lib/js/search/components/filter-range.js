$.widget("ui.search_cmp_filter_range", {

    _create: function() {
        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input'),
            timer;

        me.widgetElement = widgetElement;
        me.property = widgetElement.data('property');
        me.dynamic = widgetElement.data('dynamic');
        me.inputs = inputs;
        me.slider = widgetElement.find('.search__filters__slider');
        me.inputChanged = false;

        inputs.on('keyup change', function () {
            // Update slider when text inputs change
            me.slider.slider('values', [$(me.inputs[0]).val(), $(me.inputs[1]).val()]);

            if (timer) {
                window.clearTimeout(timer);
            }
            timer = setTimeout(
                function () {
                    $(document).trigger('search:inputChanged');
                    me.inputChanged = true;
                },
                300
            );
        });

        me.slider.slider({
            range: true,
            slide: function (event, ui) {
                $(me.inputs[0]).val(ui.values[0]).change();
                $(me.inputs[1]).val(ui.values[1]).change();
            }
        });
    },

    getValues: function() {
        var minValue = Number($(this.inputs[0]).val()),
            maxValue = Number($(this.inputs[1]).val());

        // Whether to include search results that do not have the property, e.g.
        // that have no date property.
        var includeMissing = (minValue === this.slider.slider('option', 'min')
            && maxValue === this.slider.slider('option', 'max'));

        return [{
            'type': this.property,
            'values': {
                'min': $(this.inputs[0]).val(),
                'max': $(this.inputs[1]).val(),
                'include_missing': includeMissing
            }
        }]
    },

    setValues: function(values) {
        var widgetValues;

        try {
            widgetValues = values[this.property];
        } catch(e) {}

        $(this.inputs[0]).val(widgetValues.min);
        $(this.inputs[1]).val(widgetValues.max);
    },

    getFacets: function(facets) {
        // Global aggregation that is not influenced by the search query.
        facets[this.property] = {
            'global': {
                'aggs': {
                    'range_min': {
                        'min': {
                            'field': this.property,
                            'format': 'YYYY'
                        }
                    },
                    'range_max': {
                        'max': {
                            'field': this.property,
                            'format': 'YYYY'
                        }
                    }
                }
            }
        };

        return facets;
    },

    setFacets: function(facets) {
        if (!facets[this.property]) {
            return;
        }

        // Don't set facets if this filter was the source of the search query.
        if (this.inputChanged) {
            this.inputChanged = false;

            return;
        }

        var facet = facets[this.property];

        if (facet.range_min && facet.range_min.value) {
            var minDate = new Date(facet.range_min.value),
                minYear = minDate.getFullYear(),
                minInput = $(this.inputs[0]);
            this.slider.slider('option', 'min', minYear);
            if (!minInput.val()) {
                minInput.val(minYear);
                this.slider.slider('values', 0, minYear);
            }
        }

        if (facet.range_max && facet.range_max.value) {
            var maxDate = new Date(facet.range_max.value),
                maxYear = maxDate.getFullYear(),
                maxInput = $(this.inputs[1]);
            this.slider.slider('option', 'max', maxYear);
            if (!maxInput.val()) {
                maxInput.val(maxYear);
                this.slider.slider('values', 1, maxYear);
            }
        }
    }
});
