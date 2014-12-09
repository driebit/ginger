<aside>
	{% block aside_map %}
		{% if id.location_lat and id.location_lng %}
			{% block map_title %}{% endblock %}
			<div class="aside_block aside_map">
				{% include "_map_single.tpl" id=id container="map-canvas" height=120 %}
			</div>
		{% else %}
            {% with id.o.presented_at as locations %}
                {% if locations[1].location_lat and locations[1].location_lng %}
                    {% block map_title %}{% endblock %}
                    <div class="aside_block aside_map">
                        {% include "_map_single.tpl" id=locations[1] container="map-canvas" height=120 %}
                    </div>
                {% endif %}
            {% endwith %}
		{% endif %}
	{% endblock %}

	{% block action_ginger_connections %}
        {# overwrite and add actions here #}
	{% endblock %}
	
	{% block aside_connections %}
		{% if id.s.participant %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Participants _}</h3></header>
				{% include "_list_simple.tpl" class="list-about" items=id.s.participant %}
			</section>
		{% endif %}	
		{% if id.o.presented_at %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Location _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.o.presented_at %}
			</section>
		{% endif %}	
		{% if id.o.organised_by %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Organised by _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.o.organised_by %}
			</section>
		{% endif %}	
	{% endblock %}

	{% block aside_keywords %}
		{% with id.subject as keywords %} 
			{% if keywords %}
				<section class="aside_block aside_keywords">
					<header><h3 class="section-title">{_ Keywords _}</h3></header>
					{% for key in keywords %}
						<a href="{{ key.page_url }}" class="btn btn-default" role="button">{{ key.title }}</a>
					{% endfor %}
				</section>
			{% endif %}
		{% endwith %}
	{% endblock %}

	{% block aside_context %}
		{% if id.o.fixed_context %}
			<section class="aside_block aside_fixed-content">
				<header><h3 class="section-title">{_ See Also _}</h3></header>
				{% include "_list.tpl" class="list-context" items=id.o.fixed_context  %}
			</section>
		{% elif id.subject %}
			{% with m.search[{match_objects id=id pagelen=5}] as result %}
				{% if result %}
					<section class="aside_block aside_related">
						<header><h3 class="section-title">{_ Related _}</h3></header>
						<div class="row list list-match">
							{% for r, rank in result %}
								{% include "_list_item.tpl" id=r class="col-xs-12" last=forloop.last %}
							{% endfor %}
						</div>
					</section>
				{% endif %}
			{% endwith %}
		{% endif %}
	{% endblock %}
</aside>