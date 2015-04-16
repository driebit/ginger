<li class="page__content__comment">
    <div class="page__content__comment__about">
        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    {{ comment.message }}
</li>

<li class="page__content__comment">
    <div class="page__content__comment__about">
        {% if comment.o.author %}
        {% if person.depiction %}
        <img class="page__content__comment__about__avatar" src="{% image_url comment.o.author.depiction mediaclass='img-comment-avatar' %}" alt=""/>
        {% elseif person.media|length > 0 %}
        <img class="page__content__comment__about__avatar" src="{% image_url comment.o.author.media|first mediaclass='img-comment-avatar' %}" alt=""/>
        {% elseif person.header %}
        <img class="page__content__comment__about__avatar" src="{% image_url comment.o.author.header.id mediaclass='img-comment-avatar' %}" alt=""/>
        {% endif %}
        {% endif %}

        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    {{ comment.message }}
</li>