$.widget("ui.search", {

	_create: function() {

		var me = this;

		$(document).on('search:doSearchWire', function(event, searchParameters) {

            var values = searchParameters.values;
            values.type = searchParameters.type;

            console.log(values);

            z_event('search-' + values.type , values);

		});
	}
});
