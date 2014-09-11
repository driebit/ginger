<aside>
	{% block aside_connections %}
		{% if id.s.hasstory %} 
			<h3>{_ About _}</h3>
			{% include "_list.tpl" class="list-about" items=id.s.hasstory %}
		{% endif %}
	{% endblock %}
</aside>