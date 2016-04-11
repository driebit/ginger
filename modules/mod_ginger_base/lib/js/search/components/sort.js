$.widget("ui.search_cmp_sort", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.type = 'sort';

        me.widgetElement.on('change', function() {
            $(document).trigger('search:inputChanged');
        });

    },

    getValues: function() {

        var me = this;

        if (me.widgetElement.val()) {
             return [{
                'type': me.type,
                'values': me.widgetElement.val()
            }]
        }

    },

    setValues: function(values) {

      var me = this,
          widgetValues;

      try {
         widgetValues = values[me.type];
      } catch(e) {}

      me.widgetElement.val(widgetValues);

    }


});
