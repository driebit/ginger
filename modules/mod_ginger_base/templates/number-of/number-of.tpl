{%
    with
        items|length,
        none,
        singular,
        plural
    as
        items,
        none,
        singular,
        plural
%}
    {% if items == 0 %}
        {{ none }}
    {% elseif items == 1 %}
        {{ singular }}
    {% else %}
        {{ items }} {{ plural }}
    {% endif %}
{% endwith %}
