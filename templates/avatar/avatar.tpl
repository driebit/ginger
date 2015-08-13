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

{% block button %}
    <a href="{{ href }}" id="{{ id }}" class="{{ class }} {{ extraClasses }}" >
        
        {% if image_dep %}
            {% image image_dep mediaclass="avatar" class=image_class %}
        {% else %}
            <i class="icon-profile"></i>
        {% endif %}

        {% if label %}
            <span class="{{ class }}__label">{{ label }}</span>
        {% endif %}

    </a>
{% endblock %}

{% endwith %}