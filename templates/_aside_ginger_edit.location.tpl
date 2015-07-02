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

                {% include "_admin_edit_content_date_range.tpl" show_header is_editable %}

            </section>
        {% endif %}
	{% endblock %}
	
	{% block aside_connections %}
		{% if id.s.presented_at %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Events _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.s.presented_at %}
			</section>
		{% endif %}	
		{% if id.s.located_in %} 
			<section class="aside_block aside_about">
				<header><h3 class="section-title">{_ Is here _}</h3></header>
				{% include "_list.tpl" class="list-about" items=id.s.located_in %}
			</section>
		{% endif %}	
	{% endblock %}

</aside>