{% with id.s.haspart|exclude:`name` as collections %}
    {% if collections %}
        <div class="part-of--aside">
            <h3 class="part-of__title">{_ Part of _}</h3>
            <ul>
                {% for collection in collections %}
                    {% catinclude "list/list-item.tpl" collection %}
                {% endfor %}
            </ul>
        </div>
    {% endif %}
{% endwith %}
