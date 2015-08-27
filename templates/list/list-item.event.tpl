{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

    <li style="display: inline-block; height: 300px; width: 300px; border: 2px solid blue">
        <a href="{{ id.page_url }}" class=" {{ extraClasses }}">EVENT VOORBEELD</a>
    </li>

{% endblock %}