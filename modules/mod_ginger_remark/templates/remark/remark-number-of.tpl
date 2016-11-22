{% with remarks|length as number %}
    {% if number == 0 %}
        {_ No remarks _}
    {% elseif number == 1 %}
        {_ 1 remark _}
    {% else %}
        {{ number }} {_ remarks _}
    {% endif %}
{% endwith %}
