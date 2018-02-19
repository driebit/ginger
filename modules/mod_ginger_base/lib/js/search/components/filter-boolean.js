$.widget("ui.search_cmp_filter_boolean", {

    _create: function() {
        var me = this,
            input = $(me.element.find('input').first());

        me.input = input;
        me.name = input.attr('name');

        input.on('change', function () {
            $(document).trigger('search:inputChanged');
        });
    },

    getValues: function() {
        return [{
            'type': this.name,
            'values': this.input.is(':checked')
        }];
    },

    setValues: function(values) {
        try {
           var widgetValue = values[this.name];
           this.input.attr('checked', widgetValue);
        } catch(e) {}
    },

    setFacets: function(facets) {
        if (facets[this.name]) {
            const count = facets[this.name].doc_count;
            $(this.element).find('span').html('(' + count + ')');
        }
    }
});
