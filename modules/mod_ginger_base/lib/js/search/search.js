$.widget("ui.search", {

    _create: function() {

        var me = this;

        $(document).on('search:doSearchWire', function(event, searchParameters) {

            if (!searchParameters.values) {
                searchParameters.values = {};
            }

            z_event('search-' + searchParameters.values.type, searchParameters.values);
        });
    }
});
