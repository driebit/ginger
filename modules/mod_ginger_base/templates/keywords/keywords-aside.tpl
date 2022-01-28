{% with title|default:_"Related based on these keywords:" as title %}

{% if items %}
    {% with id.o.subject as results %}
        {% if results|length > 0 %}
                <div class="keywords--aside">
                    <p class="keywords__label">{{ title }}</p>

                    <ul class="keywords__list">
                        {% for id in results %}
                            {% if id.is_visible %}
                                <li><a href="{% url page id=rsc.id type="subject" direction="object" %}" class="keywords__list__btn">{{ m.rsc[id].title }}</a></li>
                            {% endif %}
                        {% endfor %}
                    </ul>
                </div>
        {% endif %}
    {% endwith %}
{% endif %}

{% endwith %}
