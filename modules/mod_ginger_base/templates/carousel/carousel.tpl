{% with
    items,
    carousel_id,
    extraClasses,
    config,
    carousel_id,
    itemtemplate|default:"carousel/carousel-item.tpl"
as
    items,
    carousel_id,
    extraClasses,
    config,
    carousel_id,
    itemtemplate
%}
{% if items %}
    {% block carousel %}
        <ul id="{{ carousel_id }}" class="carousel {{ extraClasses }}">
            {% for id in items %}
                {% catinclude itemtemplate id %}
            {% endfor %}
        </ul>
    {% endblock %}

    {% block javascript %}
        {% javascript %}
            $('#{{ carousel_id }}').carousel({{ config }});
        {% endjavascript %}
    {% endblock %}

{% endif %}

{% endwith %}
