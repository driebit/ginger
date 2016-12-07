{% with
    records,
    extra_classes,
    class|default:"list",
    list_id|default:"",
    list_item_template|default:"list/list-item-adlib.tpl"
as
    records,
    extra_classes,
    class,
    list_id,
    list_item_template
%}
    {% if records %}
        <ul id="{{ list_id }}" class="{{ class }} {{ extraClasses }}">
            {% for record in records %}
                {% include list_item_template record=record %}
            {% endfor %}
        </ul>
    {% else %}
        <p class="no-results">{_ No results _}</p>
    {% endif %}
{% endwith %}
