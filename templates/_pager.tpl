{% if custom == true %}
    <nav class="ginger-pagination">
        {% if prev_url %}
            <a href="{{ prev_url }}" class="ginger-pagination__previous">Vorige</a>
        {% endif %}

        <ol class="ginger-pagination__pages">
            {% for nr, url in pages %}
                {% if nr %}
                    <li class="ginger-pagination__page{% if nr == page %}--active{% endif %}"><a href="{{ url }}">{{ nr }}</a></li>
                {% else %}
                    <li class="ginger-pagination__seperator"></li>
                {% endif %}
            {% endfor %}
        </ol>

        {% if next_url %}
            <a href="" class="ginger-pagination__next">Volgende</a>
        {% endif %}
    </nav>

{% else %}
    <ul class="pagination pagination-centered">
        <li {% if not prev_url %}class="disabled"{% endif %}><a href="{{ prev_url }}#content-pager">←</a></li>

        {% for nr, url in pages %}
            {% if nr %}
                <li {% if nr == page %}class="active"{% endif %}><a href="{{ url }}#content-pager">{{ nr }}</a></li>
            {% else %}
                <li class="disabled"><a href="#">…</a></li>
            {% endif %}
        {% endfor %}
        <li {% if not next_url %}class="disabled"{% endif %}><a href="{{ next_url }}#content-pager">→</a></li>
    </ul>
{% endif %}
