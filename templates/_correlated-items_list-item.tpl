<li class="{{ classPrefix }}__{{ showas }}">
    <a href="{{ item.page_url }}">
        <div class="{{ classPrefix }}__{{ showas }}__illustration">
            {% if item.header %}
                {% image item.header mediaclass="img-related" alt="" %}
            {% elseif dep %}
                {% image item.dep mediaclass="img-related" alt="" %}
            {% endif %}
        </div>

        <div class="{{ classPrefix }}__{{ showas }}__content">
            <h6 class="{{ classPrefix }}__{{ showas }}__title">
                {% if item.short_title %}
                    {{ item.short_title }}
                {% else %}
                    {{ item.title }}
                {% endif %}
            </h6>

            <p>
                {% if item.summary %}
                    {{ item.summary|striptags|truncate:200 }}
                {% else %}
                    {{ item.body|striptags|truncate:200 }}
                {% endif %}
            </p>
        </div>
    </a>
</li>
