<li class="carousel_item">
	<a href="{{ id.page_url }}" title="{{ id.title }}">
		{% if m.media[id].preview_filename %}
			{% image m.media[id].preview_filename mediaclass="carousel-image" alt=id.title %}
		{% elif id.depiction %}
			{% image id.depiction mediaclass="carousel-image" alt=id.title %}
		{% else %}
			<img src="/lib/images/default.jpg" alt="{{ id.title }}" />
		{% endif %}

		{% if id.title %}
			<h2>{{ id.title }}</h2>
		{% endif %}
	</a>
</li>
