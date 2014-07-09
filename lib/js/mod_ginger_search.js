// Define widget
$.widget("ui.suggestions", {
	_init: function() { 
		this.init();
	},

	init: function() {
		var self = this;
		var timer = null;
		var prevVal = null;
		
		$("#suggestions").hide();
		
		function doSearch() {
			var val = self.element.val();

			if (!val.length) {
				$("#suggestions").hide();
				return;
			}

			if (prevVal && val == prevVal || !val.length) {
				return;
			}

			prevVal = val;
			z_event("show_suggestions", {value: val});

			$("#suggestions").show();
		}

		self.element.on('keyup', function() {
			if (timer) {
				clearTimeout(timer);
			}

			timer = setTimeout(doSearch, 300);
		});
	}
});

// Add to widget manager.
$.widgetManager();
