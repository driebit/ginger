{% if items %}
    {% with id.o.subject as results %}
        {% if results|length > 0 %}
                <div class="keywords">
                    <p class="keywords__label">{_ Based on these keywords: _}</p>

                    <ul class="keywords__list">
                        {% for id in results %}
                            {% if id.is_visible %}
                                <li><a href="/all-in/?id={{id.id}}&type=subject&direction=object" class="keywords__list__btn">{{ m.rsc[id].title }}</a></li>
                            {% endif %}
                        {% endfor %}
                    </ul>
                </div>
        {% endif %}
    {% endwith %}
{% endif %}
