{% with id.depiction as dep %}
	<li class="list_item {% if not dep %} no-image{% endif %}">
		<a href="{{ id.page_url }}">
			{% if id.title %}
				<h3>{{ id.title }}</h3>
			{% endif %}

			{% if dep %}
				{% image dep mediaclass="list-image" alt=id.title class="img-responsive" %}
			{% endif %}

			{% if id.summary %}
				<p>{{ id.summary|truncate:100 }}</p>
			{% endif %}
		</a>
	</li>
{% endwith %}
