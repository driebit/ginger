$.widget("ui.search", {

    _create: function() {

        var me = this;

        $(document).on('search:doSearchWire', function(event, searchParameters) {


            //console.log(searchParameters);

            var values = searchParameters.values;

						values.type = searchParameters.type;


            z_event('search-' + values.type , values);

        });
    }
});
