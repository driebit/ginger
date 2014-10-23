{% if id and id.is_visible and id.is_published %}
	{% with id.depiction as dep %}
		<div class="list_item{% if not dep %} no-image{% endif %} {{ class }} {% if last %} last{% endif%}">
			<a href="{{ id.page_url }}">
				{% if dep %}
					{% image dep mediaclass="list-image" alt=id.title class="img-responsive" crop=id.depiction.id.crop_center %}
				{% else %}
					<img src="/lib/images/default.jpg" alt="{{ id.title }}" class="img-responsive" />
				{% endif %}

				{% if id.short_title %}
					<h3 class="list_item_short-title">{{ id.short_title }}</h3>
				{% else %}
					<h3 class="list_item_title">{{ id.title }}</h3>
				{% endif %}
				
				{% if id.summary %}
					<div class="list_item_content content">{{ id.summary|truncate: 200 }}</div>
				{% elseif id.body %}
					<div class="list_item_content content">{{ id.body|truncate: 200 }}</div>
				{% endif %}
			</a>
		</div>
	{% endwith %}
{% endif %}
