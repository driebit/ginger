{% block map %}
	<div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="map_canvas {{ class }}"></div>
{% endblock %}

{% block map_js %}{% endblock %}
