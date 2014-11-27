{% extends "base.tpl" %}

{% block page_class %}query{% endblock %}

{% block content %}

	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}

	{% block action_ginger_connections %}
        {% if id.is_editable %}
            <section class="ginger-edit_add-story">
                {% include "_action_ginger_connection.tpl" category='event' obj_title='event' %}
            </section>
        {% endif %}
	{% endblock %}

	{% block page_content %}
		{% with m.search.paged[{query query_id=id pagelen=24 page=q.page}] as result %}
			{% include "_list.tpl" cols="3" items=result %}
			{% pager id=id result=result hide_single_page=1 %}
		{% endwith %}
	{% endblock %}
{% endblock %}
