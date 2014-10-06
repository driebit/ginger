<aside>
	{% block aside_connections %}
		{% if id.o.about %} 
			<h3>{_ About _}</h3>
			{% include "_list.tpl" class="list-about" items=id.o.about %}
		{% endif %}
	{% endblock %}
</aside>