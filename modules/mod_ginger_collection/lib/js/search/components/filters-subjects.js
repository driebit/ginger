$.widget('ui.search_cmp_filters_subjects', {
    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;
        me.type = 'subject';

        this.loadMore();

        inputs.on('change', function () {
            $(document).trigger('search:inputChanged');
        });
    },

    loadMore: function() {
        var me = this,
            btn = $('.filter-down-btn'),
            listItem = me.widgetElement.find('li.rest-subject'),
            counter = 0;

        btn.on('click', function () {
            counter = counter + 10;

            $.each(listItem, function(i , val){
                if(i < counter) {
                    $(val).removeClass('hidden');
                }
            });

            $(this).toggleClass('open');
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
        facets.keyword = {
            'field': 'dcterms:subject.rdfs:label.keyword',
            'size': 100
        };

        return facets;
    },

    setFacets: function(facets) {
        if (facets.keyword) {
            var values = this.getValues()[0].values;
            z_event('update_filter_subjects', {'buckets': facets.keyword.buckets, 'values': values});
        }
    }
});
