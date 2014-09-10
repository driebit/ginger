{% if items %}
	<ul class="row list {{ class }}">
		{% for id in items %}
			{% if cols == '3' %}
				{% catinclude "_list_item.tpl" id class="col-xs-12 col-sm-6 col-md-4" %}
			{% elif cols == '2' %}
				{% catinclude "_list_item.tpl" id class="col-xs-12 col-sm-6" %}
			{% else %}
				{% catinclude "_list_item.tpl" id class="col-xs-12 no-padding" %}
			{% endif %}
		{% endfor %}
	</ul>
{% endif %}