<aside>
	{% with m.rsc[id] as r %}

		{% block keywords %}
			{% with r.subject as keywords %} 
				{% if keywords %}
					<h3>{_ Keywords _}</h3>
					<div class="well">
						{% include "_list.tpl" type="text" class="list-keywords" items=r.subject %}
					</div>
				{% endif %}
			{% endwith %}
		{% endblock %}

		{% block about %}
			{% if r.o.about %} 
				<h3>{_ About _}</h3>
				{% include "_list.tpl" type="image" class="list-about" items=r.subject %}
			{% endif %}
		{% endblock %}

		{% block context %}
			<h3>{_ See Also _}</h3>
			{% if r.o.fixed_context %}
				{% include "_list.tpl" type="image" class="list-context" items=r.o.fixed_context  %}
			{% elif r.subject %}
				{% with m.search[{match_objects id=id pagelen=5}] as match %}
				    {% if match %}
				        <ul class="list list-image list-match">
				            {% for id, rank in match %}
				                {% catinclude "_list_item_image.tpl" id %}
				            {% endfor %}
				        </div>
				    {% endif %}
				{% endwith %}
			{% endif %}
		{% endblock %}

	{% endwith %}
</aside>