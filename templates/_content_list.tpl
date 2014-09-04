{% if list %}
	{% if title %}
		<h4 class="section-title">{{ title }}</h4>
	{% endif %}
    <div class="list-group">
        {% for id in list %}
            {% catinclude "_list_item.tpl" id counter=forloop.counter %}
        {% endfor %}
    </div>
{% endif %}