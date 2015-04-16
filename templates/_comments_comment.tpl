<li class="page__content__comment">
    <div class="page__content__comment__about">
        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    {{ comment.message }}
</li>

<li class="page__content__comment">
    <div class="page__content__comment__about">
        {% if m.rsc[comment.user_id] %}
            {% if m.rsc[comment.user_id].depiction %}
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].depiction mediaclass='img-comment-avatar' %}" alt=""/>
            {% elseif m.rsc[comment.user_id].media|length > 0 %}
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].media|first mediaclass='img-comment-avatar' %}" alt=""/>
            {% elseif m.rsc[comment.user_id].header %}
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].header.id mediaclass='img-comment-avatar' %}" alt=""/>
            {% endif %}
        {% endif %}

        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    {{ comment.message }}
</li>