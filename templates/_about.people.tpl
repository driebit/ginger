{% if people %}
    <div class="page__content__about--people">
        <h3 class="page__content__about__header">{{ title }}</h3>
        <p class="page__content__about__content">
            {% for person in people %}
                <a href="{{ person.page_url }}">{{ person.title }}</a>
            {% endfor %}
        </p>
    </div>
{% endif %}
