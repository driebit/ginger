<aside>
	{% with m.rsc[id] as r %}
		{% block keywords %}
			{% with r.subject as keywords %} 
				{% if keywords %}
					<h3>{_ Keywords _}</h3>
					{% for key in keywords %}
						<a href="{{ key.page_url }}" class="btn btn-default" role="button">{{ key.title }}</a>
					{% endfor %}
				{% endif %}
			{% endwith %}
		{% endblock %}

		{% block about %}
			{% if r.o.about %} 
				<h3>{_ About _}</h3>
				{% include "_list.tpl" class="list-about" items=r.o.about %}
			{% endif %}
		{% endblock %}

		{% block context %}
			{% if r.o.fixed_context %}
				<h3>{_ See Also _}</h3>
				{% include "_list.tpl" class="list-context" items=r.o.fixed_context  %}
			{% elif r.subject %}
				{% with m.search[{match_objects id=id pagelen=5}] as result %}
					{% if result %}
						<h3>{_ See Also _}</h3>
						<ul class="row list list-match">
							{% for id, rank in result %}
								{% include "_list_item_.tpl" id class="col-xs-12 no-padding" %}
							{% endfor %}
						</ul>
					{% endif %}
				{% endwith %}
			{% endif %}
		{% endblock %}

	{% endwith %}
</aside>