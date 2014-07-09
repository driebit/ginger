// Define widget
setTimeout(function() {
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

				console.log(val);

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

			$(document).mouseup(function (e) {
			    var container = $(".search-form");

			    if (!container.is(e.target) // if the target of the click isn't the container...
			        && container.has(e.target).length === 0) // ... nor a descendant of the container
			    {
			        $("#suggestions").hide();
			    }
			});
		}
	});

	// Add to widget manager.
	$.widgetManager();
}, 200);