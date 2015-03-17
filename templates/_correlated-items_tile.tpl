<li class="{{ prefix }}__tile">
    <a href="{{ item.page_url }}">
        <div class="{{ prefix }}__illustration">
            {% if item.header %}
                {% image item.header mediaclass=mediaclass alt=item.title %}
            {% elseif dep %}
                {% image item.dep mediaclass=mediaclass alt=item.title %}
            {% endif %}
        </div>

        <div class="{{ prefix }}__content">
            <h6 class="{{ prefix }}__title">
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
