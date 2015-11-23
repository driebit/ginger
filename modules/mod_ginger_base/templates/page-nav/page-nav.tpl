{% if id.o.hasbutton %}
    <div class="page-nav">
        {% for r in id.o.hasbutton %}
            {% if r.o.haspart %}
                <div class="page-nav__container">
                    <h3 class="page-nav__title">{{ r.title }}</h3>
                    {% for btn in r.o.haspart %}
                        <a href="{{ btn.page_url }}" class="btn--primary">{{ btn.title }}</a>
                    {% endfor %}
                </div>
            {% else %}
                <a href="{{ r.page_url }}" class="btn--primary">{{ r.title }}</a>
            {% endif %}
        {% endfor %}
    </div>
{% endif %}
