{% if id.publication_start|date:"Y" %}
    <time class="published" datetime='{{ id.date_end|date:"Y-t-dTH:m" }}'>{{ id.publication_start|date:"j F Y" }}</time>
{% endif %}
