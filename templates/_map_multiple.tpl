{% block map %}
	<div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="map_canvas {{ class }}"></div>
{% endblock %}

{% javascript %}
	var locations = [];

	{% for id in items %}
		{% if id.location_lat and id.location_lng %}
			locations.push({
				lat: '{{ id.location_lat }}',
				lng: '{{ id.location_lng }}',
				zoom: '{{ id.location_zoom_level }}',
				content: '{{ id.title }}'
			});
		{% endif %}
	{% endfor %}

	if (locations.length) {
		var map = new ginger_map({
			container: '{{ container }}',
			locations: locations
		});
	}
{% endjavascript %}