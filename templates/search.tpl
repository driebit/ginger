{% extends "page.query.tpl" %}

{% block content %}
	{% if q.qs %}
		{% block page_title %}
			<h2 class="page-header">{_ Searching for _} <span>{{ q.qs|escape }}</span></h2>
		{% endblock %}		
		
		{% block page_content %}

			{% block content_title %}{% endblock %}

			{% with m.search.paged[{query	text=q.qs pagelen=24 page=q.page}] as result %}
				{% if result.total > 0 %}
					{% include "_list.tpl" cols="3" items=result %}
					{% pager result=result hide_single_page=1 %}
				{% else %}
					<p>{_ No results _}</p>
				{% endif %}
			{% endwith %}
		{% endblock %}
	{% endif %}
{% endblock %}