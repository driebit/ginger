<aside>

	{% block action_ginger_connections %}
        {% if id.is_editable %}
            <section class="aside_block aside_stories">

                <header><h3 class="section-title">{_ Keyword _}</h3></header>
                {% include "_action_ginger_connection.tpl" category='keyword' predicate='subject' new_rsc_title=_'Keyword' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.subject.id] %}
				<header><h3 class="section-title">{_ Location _}</h3></header>
                {% include "_action_ginger_connection.tpl" category='location' predicate='presented_at' new_rsc_title=_'Location' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.presented_at.id] %}
				<header><h3 class="section-title">{_ Organized by _}</h3></header>
                {% include "_action_ginger_connection.tpl" category='location' predicate='organised_by' new_rsc_title=_'Location' tab='find' %}
                {% include "_ginger_connection_widget.tpl" predicate_ids=[m.rsc.organised_by.id] %}

                {% include "_admin_edit_content_date_range.tpl" show_header is_editable %}

            </section>
        {% endif %}
	{% endblock %}
	


</aside>