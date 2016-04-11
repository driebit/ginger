$.widget("ui.search_cmp_types", {

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.widgetElement = widgetElement;
        me.type = 'type';

        me.widgetElement.on('click', '.btn--result-option', function() {
            var type = $(this).attr('href').replace(/#/, '');
            me.setType(type);
            $(document).trigger('search:inputChanged');
            return false;
        });

    },

    getValues: function() {

        var me = this,
            el = $('.btn--result-option.is-active');

        return [{
            'type': me.type,
            'values': el.attr('href').replace(/#/, '')
        }]
    },

    setValues: function(values) {

        var me = this,
            type;

        try {
            type = (values[me.type]) ? values[me.type] : 'list';
        } catch (e) {}

        if (type) me.setType(type);

    },

    setType: function(type) {

        var buttonEl = $('[href="#' + type + '"]');

        $('.btn--result-option').removeClass('is-active');

        buttonEl.addClass('is-active');

        $('.search__result__container').hide();
        $('#search-' + type).show();
        $('#search-' + type).css('visibility', 'visible');

    }

});
