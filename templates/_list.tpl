<ul class="list list-{{ type }} {{ class }}">
	{% for id in items %}
		{% if type == 'text' %}
			{% catinclude "_list_item_text.tpl" id %}
		{% elif type == 'image' %}
			{% catinclude "_list_item_image.tpl" id %}
		{% endif %}
	{% endfor %}
</ul>
