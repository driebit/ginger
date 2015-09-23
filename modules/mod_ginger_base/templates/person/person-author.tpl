
 {% for author in id.o.author %}
     {% if author %}
        <a href="{{ author.page_url }}" class="person-author">
            {% include "avatar/avatar.tpl" id=author %}
            <div class="person-author__text"><span>{_ Door: _}</span> {{ author.title }}</div>
        </a>
    {% endif %}
 {% endfor %}


