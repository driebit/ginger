{% if items %}
	<ul class="row list list-{{ type }} {{ class }}">
		{% for id in items %}
			{% if type == 'text' %}
				{% catinclude "_list_item_text.tpl" id %}
			{% elif type == 'image' %}
				{% if cols == '3' %}
					{% catinclude "_list_item_image.tpl" id class="col-xs-12 col-sm-6 col-md-4" %}
				{% elif cols == '2' %}
					{% catinclude "_list_item_image.tpl" id class="col-xs-12 col-sm-6" %}
				{% else %}
					{% catinclude "_list_item_image.tpl" id class="col-xs-12 no-padding" %}
				{% endif %}
			{% endif %}
		{% endfor %}
	</ul>
{% endif %}