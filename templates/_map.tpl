{% if items %}
	{% block map %}
		<div class="location">
			<div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="location_map {{ class }}"></div>
			{% if addlink == true %}
				<a href='http://maps.google.com/maps?q={{ r.location_lat }},{{ r.location_lng }}' class="location_link" target="_blank">
					{_ Show larger map _}
				</a>
			{% endif %}
		</div>
	{% endblock %}

	{% block map_js %}
		<script>
			$(document).ready(function() {
				var locations = [];
				{% for id in items %}
					{% if id.location_lat and id.location_lng %}
						locations.push({
							title: '{{ id.title }}',
							url: '{{ id.page_url }}',
							lat: '{{ id.location_lat }}',
							lng: '{{ id.location_lng }}',
							zoom: '{{ id.location_zoom_level }}',
							summary: '{{ id.summary|truncate:100 }}'
						});
					{% endif %}
				{% endfor %}

				if (locations.length) {
					var map = new ginger_map({
						container: '{{ container }}',
						locations: locations
					});
				}
			});
		</script>
	{% endblock %}

{% endif %}