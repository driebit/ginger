<head>
    {% all include "_html_head.tpl" %}

    {% block css %}
        {% lib
            "css/site/screen.css"
        %}
    {% endblock %}

    {% all include "_html_head_extra.tpl" %}
</head>
