{% block map %}
	<div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="map_canvas {{ class }}"></div>
{% endblock %}

{% javascript %}
	var locations = [];

	{% with m.search[{geo_nearby id=id distance=1000 pagelen=limit}] as locations %}
		{% for loc in locations %}
			{% if loc.location_lat and loc.location_lng %}
				locations.push({
					lat: '{{ loc.location_lat }}',
					lng: '{{ loc.location_lng }}',
					zoom: '{{ loc.location_zoom_level }}',
					content: '{{ loc.title }}'
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
{% endjavascript %}
