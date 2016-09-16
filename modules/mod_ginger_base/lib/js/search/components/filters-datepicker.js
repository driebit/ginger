$.widget("ui.search_cmp_filters_datepicker", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.dateSelected = null; //date object, used for comparing the previously selected date with the current
        me.type = 'ongoing_on_date';

        $(document).on('search:DatePickerOnSelect', function() {
            $(document).trigger('search:inputChanged');
        });

        $(document).on('widgetmanager:loaded', function() {
            var picker = me.widgetElement.find('div:eq(0)').datepicker();

            $.datepicker.setDefaults($.datepicker.regional['nl']);

            picker.datepicker('option', 'onSelect', function() {

                //only called when the user clicks in the interface, not from setDate

                var date = me.widgetElement.find('div:eq(0)').datepicker('getDate');

                if (me.dateSelected != null) {
                    if (date.getDate() == me.dateSelected.getDate()) {
                        me.dateSelected = null;
                        me.selectNone();
                    } else {
                        me.dateSelected = date;
                    }
                } else {
                    me.dateSelected = date;
                }

                $(document).trigger('search:DatePickerOnSelect', arguments);

            });

        });

    },

    selectNone: function() {

        var me = this,
            picker = me.widgetElement.find('div:eq(0)').datepicker();

        picker.datepicker('option', 'setDate', null); //does work, nothing visual though
        setTimeout(function() {
            $('.ui-datepicker-current-day a').removeClass('ui-state-active').removeClass('ui-state-hover');
            $('.ui-datepicker-current-day').removeClass('ui-datepicker-current-day');
        }, 0);

    },

    getValues: function() {

        var me = this,
            widgetElement = me.widgetElement,
            picker = me.widgetElement.find('div:eq(0)').datepicker(),
            date = picker.datepicker('getDate');

        if (!date || !me.dateSelected) return false;

        return [{
            'type': 'ongoing_on_date',
            'values': date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()
        }];

    },


    setValues: function(values) {

        var widgetValues,
            me = this;

        try {
            widgetValues = values[me.type];
        } catch (e) {}

        if (widgetValues) {

            var widgetElement = me.widgetElement,
                el = me.widgetElement.find('div:eq(0)'),
                date = new Date(widgetValues);

            me.dateSelected = date;
            el.datepicker('setDate', date);

        } else {

            me.selectNone();

        }
    }

});
