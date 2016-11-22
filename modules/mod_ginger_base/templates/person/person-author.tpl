{%
    with
        class|default:"person-author__text",
        authors|default:(id.o.author|is_visible)|default:[id.creator_id]|is_visible
    as
        class,
        authors
%}
    {% if authors %}
        <div class="{{ class }}">
            <span class="{{ class }}__by">{_ By: _}</span>

            {% for author in authors %}
                <a href="{{ author.page_url }}" class="person-author">
                    {% include "avatar/avatar.tpl" id=author %} {{ author.title }}{% if not forloop.last %}, {% endif %}
                </a>
            {% endfor %}
        </div>
    {% endif %}
{% endwith %}
