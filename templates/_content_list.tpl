{% if list %}
	{% if title %}
		<h4 class="section-title">{{ title }}</h4>
	{% endif %}
    <ul class="grid">
        {% for id in list %}
            {% catinclude "_grid_item.tpl" id counter=forloop.counter %}
        {% endfor %}
    </ul>
{% endif %}