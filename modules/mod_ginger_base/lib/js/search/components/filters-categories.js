$.widget("ui.search_cmp_filters_categories", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element),
            inputs = widgetElement.find('input');

        me.widgetElement = widgetElement;

        inputs.on('change', function() {
            $(document).trigger('search:inputChanged');
        });

    },

    getValues: function() {

        var me = this,
            inputs = me.widgetElement.find('input:checked'),
            values;
  
        values = $.map(inputs, function( input ) {
            return $(input).val();
        });

        //must return an array of objects
        return [{
                'type': 'cat',
                'values': values
            }
        ]
    }

});
