
$.widget("ui.search_cmp_pager", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement,
        me.value = null;

        me.widgetElement.on('click', 'a', function(event) {

           var  matches = $(this).attr('href').match(/page=(\d*)[^\d]/),
                page = (matches && matches[1]) ? matches[1] : 1;

           me.value = page;

           $(document).trigger('search:inputChanged');

           event.stopPropagation();
           return false;

        });

    },

    getValues: function() {


         var me = this,
             values;

        if (!me.value) return false;

        return [{
                'type': 'page',
                'values': parseInt(me.value)
            }
        ]
    }



});
