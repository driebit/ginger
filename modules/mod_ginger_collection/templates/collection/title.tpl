{% with
    title,
    truncate
as
    title,
    truncate
%}
    {% if truncate %}
        {{ title|truncate:truncate }}
    {% else %}
        {{ title }}
    {% endif %}
{% endwith %}
