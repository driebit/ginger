{% extends "base.tpl" %}

dit is het page template

{% block content %}
    {% with m.search[{match_objects id=id pagelen=5}] as result %}
        {% if result %}
            {% for r, rank in result %}
                {{r.title}}<br>
            {% endfor %}
        {% endif %}
    {% endwith %}
{% endblock %}
