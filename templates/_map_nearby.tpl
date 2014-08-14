{% extends "_map.tpl" %}

{% block map_js %}
	<script>
		$(document).ready(function() {
			var locations = [];

			{% with m.search[{geo_nearby id=id distance=1000 pagelen=limit}] as locations %}
				{% for loc in locations %}
					{% if loc.location_lat and loc.location_lng %}
						locations.push({
							lat: '{{ loc.location_lat }}',
							lng: '{{ loc.location_lng }}',
							zoom: '{{ loc.location_zoom_level }}',
							content: '{% include "_info_window.tpl" id=loc %}'
						});
					{% endif %}
				{% endfor %}
			{% endwith %}

			if (locations.length) {
				var map = new ginger_map({
					container: '{{ container }}',
					locations: locations,
					highlight: 0
				});
			}
		});
	</script>
{% endblock %}
