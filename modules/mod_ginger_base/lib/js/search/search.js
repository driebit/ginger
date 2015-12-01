$.widget("ui.search", {

	_create: function() {

		var me = this;

		$(document).on('search:doSearch', function(event, searchParameters) {

            var values = searchParameters.values,
                type = searchParameters.type;
            
            console.log(values);

            z_event('search-' + type, values);

		});

	}

});
