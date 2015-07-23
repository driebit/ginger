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
    
        {% if image_dep %}
            {% image image_dep mediaclass="avatar" class=image_class %}
        {% else %}
            <i class="icon-profile"></i>
        {% endif %}
    {% if label %}
        {{ label }}
    {% endif %}
</a>

{% endwith %}