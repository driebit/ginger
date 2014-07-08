setTimeout(function() {
	$.widget("ui.show_search_results", {
		_init: function() { 
			this.init();
			console.log('jemoeder');
		},
		 
		init: function() {
			var self = this;
			var timer = null;
			var prevVal = null;
			
			$("#search-results").hide();
			
			function doSearch() {
				console.log('DEBUG');
				var val = self.element.val();
				if (!val.length) {
					$("#search-results").hide();
					return;
				}                             
				if (prevVal && val == prevVal || !val.length) {
					return;
				}
				prevVal = val;
				// call Zotonic
				z_event("show_search_results", {value: val});
				$("#search-results").show();
			}

			self.element.on('keyup', function() {
				if (timer) {
					clearTimeout(timer);
				}
				timer = setTimeout(doSearch, 300);
			});
		}
	});

	$.widgetManager();

}, 200);