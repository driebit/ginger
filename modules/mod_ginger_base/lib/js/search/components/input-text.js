$.widget("ui.search_cmp_input_text", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.type = 'qs';

        me.widgetElement.keypress(function(event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                $(document).trigger('search:inputChanged');
            }
        });

        if (widgetElement.data('instant')) {
            var timer = null;

            me.widgetElement.on('keyup', function() {
                if (timer) clearTimeout(timer);
                timer = setTimeout(
                    function() {
                        $(document).trigger('search:inputChanged')
                    },
                    300
                );
            });
        }
    },

    getValues: function() {

        var me = this,
            value = ($.url().param('qs') != '' && !window.location.hash) ? value = $.url().param('qs') : me.widgetElement.val();

        return [{
            'type': me.type,
            'values': value
        }]
    },

    setValues: function(values) {

        var me = this,
            widgetValues;

        try {
           widgetValues = values[me.type];
        } catch(e) {}

        me.widgetElement.val('');

        if (widgetValues) {
            me.widgetElement.val(widgetValues);
        }
    }

});
