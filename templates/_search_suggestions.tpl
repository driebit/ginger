{# Add one or more cat="NAME" to the query below to filter the results #}
{% with m.search[{query text=q.value pagelen=12}] as results %}
	
	{% if results %}
		{% for cat in results|group_by:`category_id` %}
			<h4>{{ cat[1].category_id.title }}</h4>
			<ul>
				{% for id in cat %}
					<li>
						<a href="{{ id.page_url }}">{{ id.title }}</a>
					</li>
				{% endfor %}
			</ul>
		{% endfor %}
	{% else %}
		<span>{_ Nothing found _}</span>
	{% endif %}
	
{% endwith %}