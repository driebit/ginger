{% if items %}
    {% with id.id as page_id %}
	<div class="row list {{ class }}">
		{% for id in items %}
			{% if cols == '3' %}
				{% catinclude "_list_item.tpl" id page_id=page_id predicate=predicate class="col-xs-12 col-sm-6 col-md-4" last=forloop.last %}
			{% elif cols == '2' %}
				{% catinclude "_list_item.tpl" id page_id=page_id predicate=predicate class="col-xs-12 col-sm-6" last=forloop.last %}
			{% else %}
				{% catinclude "_list_item.tpl" id page_id=page_id predicate=predicate class="col-xs-12" last=forloop.last %}
			{% endif %}
		{% endfor %}
	</div>
    {% endwith %}
{% endif %}