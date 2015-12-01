$.widget("ui.search_cmp_sort", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;

        me.widgetElement.on('change', function() {
            $(document).trigger('search:inputChanged');
        });
       
    },

    getValues: function() {

        var me = this;

        if (me.widgetElement.val()) {
             return [{
                'type': 'sort',
                'values': me.widgetElement.val()
            }]
        }       
    }

});
