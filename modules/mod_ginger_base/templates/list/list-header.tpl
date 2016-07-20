{% if items %}
    <div class="list-header">
        <h2 class="list-header__title">
            {% if r.id %}
                <a href="{{ r.page_url }}">{{ list_title }}</a>
            {% else %}
                <span>{{ list_title }} {% if help %}{% button text=" " title={_ What does this mean _} class="z-btn-help" action={dialog title=help_title text=help_text } %} {% endif %}</span>
            {% endif %}
        </h2>
    </div>
{% endif %}
