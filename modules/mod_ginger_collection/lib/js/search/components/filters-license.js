$.widget('ui.search_cmp_filters_license', {
    _create: function() {
        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.type = 'license';

        widgetElement.on('change', function() {
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

        return [{
            'type': me.type,
            'values': values
        }];
    },

    setValues: function(values) {
        var me = this,
            widgetValues,
            inputs = me.widgetElement.find('input');

        try {
           widgetValues = values[me.type];
        } catch(e) {}

        $.each(inputs, function(i, input) {
            $(input).removeAttr('checked');
        });

        if (widgetValues && widgetValues.length > 0) {
            $.each(inputs, function(i, input) {
                if ($.inArray($(input).val(), widgetValues) !== -1) {
                    $(input).attr('checked', 'checked');
                }
            });
        }
    },

    getFacets: function(facets) {
        facets.license = {
            'global': {
                'aggs': {
                    'license_keyword': {
                        'terms': {
                            'field': 'dcterms:license.keyword'
                        }
                    }
                }
            }
        };

        return facets;
    },

    setFacets: function(facets) {
        if (facets.license) {
            var values = this.getValues()[0].values;
            z_event('update_filter_license', {'buckets': facets.license.license_keyword.buckets, 'values': values});
        }
    }
});
