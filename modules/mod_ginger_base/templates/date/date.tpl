{% with format|default:"j F Y e" as format %}<time datetime="{{ date|date:"Y-m-d" }}" class="{{ name }}">{{ date|date:format }}</time>{% endwith %}
