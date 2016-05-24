{% with title|default:_"About:" as title %}
{% with id.o.about|exclude:`name` as about %}
    {% if about %}
        <div class="part-of--aside">
            <h3 class="part-of__title">{{ title }}</h3>
            <ul>
                {% for r in about %}
                    {% include "list/list-item.tpl" id=r %}
                {% endfor %}
            </ul>
        </div>
    {% endif %}
{% endwith %}
{% endwith %}
