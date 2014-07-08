{% with m.search[{query text=q.value cat="project" cat="news" pagelen=12}] as results %}

	{% if results %}
		{% for category in results|group_by:`category_id` %}
			<h4>{{ category[1].category_id.title }}</h4>
			<ul>
				{% for id in category %}
					<li><a href="{{ id.page_url }}">{{ id.title }}</a></li>
				{% endfor %}
			</ul>
		{% endfor %}
	{% else %}
		<span>{_ Nothing found _}</span>
	{% endif %}
	
{% endwith %}