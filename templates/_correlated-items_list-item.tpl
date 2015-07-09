<li class="{{ classPrefix }}__{{ showas }}">
    <a href="{{ item.page_url }}">

        <div class="{{ classPrefix }}__{{ showas }}__illustration">
            {% if item.header %}
                {% image item.header mediaclass="img-related" alt="" %}
            {% elseif item.depiction %}
                {% image item.depiction mediaclass="img-related" alt="" %}
            {% elseif item.media|length > 0 %}
                {% image item.media|first mediaclass="img-related" alt="" %}
            {% elseif item.o.hasicon and item.o.hasicon.depiction %}
                {% with item.o.hasicon.depiction as hasicon_dep %}
                    {% image hasicon_dep mediaclass="img-related" alt=item.title class="img-related" crop=hasicon_dep.id.crop_center %}
                {% endwith %}   
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
