$.widget("ui.suggestions", {
	_init: function() {
		this.init();
	},

	init: function() {
		var self = this;
		var timer = null;
		var prevVal = null;

		$("#search-suggestions").hide();

		function doSearch() {
			var val = self.element.val();

			if (!val.length) {
				$("#search-suggestions").hide();
				return;
			}

			if (prevVal && val == prevVal || !val.length) {
				return;
			}

			prevVal = val;
			z_event("show_suggestions", {value: val});

			$("#search-suggestions").show();
		}

		self.element.on('keyup', function() {
			if (timer) {
				clearTimeout(timer);
			}

			timer = setTimeout(doSearch, 300);
		});

		$(document).mouseup(function (e) {
		    var container = $("#search-form");

		    if (!container.is(e.target) // if the target of the click isn't the container...
		        && container.has(e.target).length === 0) // ... nor a descendant of the container
		    {
		        $("#search-suggestions").hide();
		    }
		});
	}
});
