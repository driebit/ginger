<aside>
	{% block aside_connections %}
		{% if id.o.about %} 
            <section class="aside_block aside_story">
    			<header><h3>{_ About _}</h3></header>
    			{% include "_list.tpl" class="list-about" items=id.o.about %}
            </section>
		{% endif %}
	{% endblock %}
</aside>