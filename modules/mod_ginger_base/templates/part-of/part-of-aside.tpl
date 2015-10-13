{% with id.s.haspart as collections %}
    {% if collections %}
        <div class="part-of--aside">
            <h3 class="part-of__title">{_ Part of: _}</h3>
            <ul>
                {% for collection in collections %}
                    {% include "list/list-item.tpl" id=collection %}
                {% endfor %}
            </ul>
        </div>
    {% endif %}
{% endwith %}
