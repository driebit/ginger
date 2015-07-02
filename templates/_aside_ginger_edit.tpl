<aside>

	{% block action_ginger_connections %}
        {% if id.is_editable %}
            <section class="aside_block aside_stories">

                <header><h3 class="section-title">{_ Keyword _}</h3></header>
                {% include "_action_ginger_connection.tpl" callback='zAdminConnectDone' newtab='false' category='keyword' predicate='subject' new_rsc_title=_'Keyword' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.subject.id] %}
				<header><h3 class="section-title">{_ Author _}</h3></header>
                {% include "_action_ginger_connection.tpl" callback='zAdminConnectDone' newtab='false' category='person' predicate='author' new_rsc_title=_'Author' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.author.id] %}
				<header><h3 class="section-title">{_ Location _}</h3></header>
                {% include "_action_ginger_connection.tpl" callback='zAdminConnectDone' newtab='false' category='location' predicate='located_in' new_rsc_title=_'Location' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.located_in.id] %}

                {% include "_admin_edit_content_date_range.tpl" show_header is_editable %}

            </section>
        {% endif %}
	{% endblock %}
	
	{% block aside_connections %}
		{% if id.s.haspart %} 
			<section class="aside_block aside_partof">
				<header><h3 class="section-title">{_ Part of _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.s.haspart %}
			</section>
		{% endif %}	
		{% if id.o.about %}
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ About _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.o.about %}
			</section>
		{% endif %}	
		{% if id.o.blogposting %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Posted in _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.o.blogposting %}
			</section>
		{% endif %}	
	{% endblock %}

</aside>