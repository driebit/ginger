<aside>
	{% block aside_map %}
		{% if id.location_lat and id.location_lng %}
			<div class="aside_map">
				{% include "_map_single.tpl" id=id container="map-canvas" height=260 %}
			</div>
		{% endif %}
	{% endblock %}

	{% block aside_keywords %}
		{% with id.subject as keywords %} 
			{% if keywords %}
				<h3>{_ Keywords _}</h3>
				{% for key in keywords %}
					<a href="{{ key.page_url }}" class="btn btn-default" role="button">{{ key.title }}</a>
				{% endfor %}
			{% endif %}
		{% endwith %}
	{% endblock %}

	{% block aside_edit_page_connections %}
		{% include "_ginger_edit_page_connections.tpl" %}
	{% endblock %}

	{% block aside_connections %}
		{% if id.o.about %} 
			<h3>{_ About _}</h3>
			{% include "_list.tpl" class="list-about" items=id.o.about %}
		{% endif %}	
	{% endblock %}

	{% block aside_context %}
		{% if id.o.fixed_context %}
			<h3>{_ See Also _}</h3>
			{% include "_list.tpl" class="list-context" items=id.o.fixed_context  %}
		{% elif id.subject %}
			{% with m.search[{match_objects id=id pagelen=5}] as result %}
				{% if result %}
					<h3>{_ See Also _}</h3>
					<div class="row list list-match">
						{% for r, rank in result %}
							{% include "_list_item.tpl" id=r class="col-xs-12" %}
						{% endfor %}
					</div>
				{% endif %}
			{% endwith %}
		{% endif %}
	{% endblock %}
</aside>