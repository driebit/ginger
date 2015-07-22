{% with
    class|default:"#",
    href|if_undefined:"#",
    image_class|default:"avatar",
    label
as
    class,
    href,
    image_class,
    label
%}

<a href="{{ href }}" id="{{ id }}" class="{{ class }}" >
    <i>
        {% if image_dep %}
            {% image image_dep mediaclass="avatar" class=image_class %}
        {% else %}
            FALLBACK ICON
            {# TODO: fallback icon #}
        {% endif %}
    </i>
    {% if label %}
        {{ label }}
    {% endif %}
</a>

{% endwith %}