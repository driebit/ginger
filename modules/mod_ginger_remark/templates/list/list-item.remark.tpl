{% if id.is_visible %}

    <li class="remark-item {{ extraClasses }}">
        {% include "page-actions/page-action-edit-thing.tpl" extraClasses="edit-button--list-item" id=id %}
        <article>
            <div class="remark-item__author">
                    {% if id.o.author as author %}
                        {% include "avatar/avatar.tpl" %}
                    {% else %}
                        {% include "avatar/avatar.tpl" author=m.rsc[id.creator_id] %}
                    {% endif %}
                <div class="remark-item__author__text">

                    {% if id.o.author as author %}
                        <b>{{ author.title }}</b>
                    {% else %}
                        <b>{{ m.rsc[id.creator_id].title }}</b>
                    {% endif %}
                    {# id.created|timesince:id.modified:"":1 #}
                    <time datetime="{{ id.created|date:"Y-F-jTH:i" }}">{{ id.created|date:"d F Y" }}</time>
                </div>
            </div>

            <div class="remark-item__content">
                <h3 class="remark-item__content__title">
                    {% if id.short_title %}
                        {{ id.short_title }}
                    {% else %}
                        {{ id.title }}
                    {% endif %}
                </h3>
                <div class="remark-item__content__body">
                    {{ id.body|show_media }}
                </div>
                {% with id.media|without_embedded_media:id|first as dep %}
                    {% catinclude "media/media.image.tpl" dep %}
                {% endwith %}

                {% block about %}
                    {% if id.id != id.o.comment.id %}
                        <a href="{{ id.o.comment.page_url }}">Dit is een reactie op: {{ id.o.comment.title }}</a>
                    {% endif %}
                {% endblock %}
            </div>
        </article>
    </li>

{% endif %}

