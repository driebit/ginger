{% extends "_map.tpl" %}

{% block map_js %}
	<script>
		$(document).ready(function() {
			var locations = [];

			{% if id.location_lat and id.location_lng %}
				locations.push({
					lat: '{{ id.location_lat }}',
					lng: '{{ id.location_lng }}',
					zoom: '{{ id.location_zoom_level }}',
					content: '{% include "_info_window.tpl" id=id %}'
				});
			{% endif %}

			if (locations.length) {
				var map = new ginger_map({
					container: '{{ container }}',
					locations: locations
				});
			}
		});
	</script>
{% endblock %}