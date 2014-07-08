{% with m.rsc[id] as r %}

	{% block map %}	
		<div id="{{ container }}" style="height: {% if height %}{{ height}}px{% else %}100%{% endif %}"></div>
	{% endblock %}

	{% block map_script %}
		<script>
			$(document).ready(function() {
				var map = new ginger_map({
					container: '{{ container }}',
					title: '{{ r.title }}',
					lat: {{ r.location_lat }},
					lng: {{ r.location_lng }},
					zoom: {% if r.location_zoom_level %}{{ r.location_zoom_level }}{% else %}10{% endif %}
				});
			});
		</script>
	{% endblock %}

{% endwith %}