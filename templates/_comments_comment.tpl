<li class="page__content__comment cf">
    {% if m.rsc[comment.user_id] %}
        {% if m.rsc[comment.user_id].depiction %}
            <div class="page__content__comment__about">
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].depiction mediaclass='img-comment-avatar' %}" alt=""/><br/>
        {% elseif m.rsc[comment.user_id].media|length > 0 %}
            <div class="page__content__comment__about">
                media
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].media|first mediaclass='img-comment-avatar' %}" alt=""/><br/>
        {% elseif m.rsc[comment.user_id].header %}
            <div class="page__content__comment__about">
                header
                <img class="page__content__comment__about__avatar" src="{% image_url m.rsc[comment.user_id].header.id mediaclass='img-comment-avatar' %}" alt=""/><br/>
        {% else %}
            <div class="page__content__comment__about has-no-avatar">
        {% endif %}
    {% else %}
        <div class="page__content__comment__about has-no-avatar">
    {% endif %}

        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    <div class="page__content__comment__body">
        {{ comment.message|unescape }}
    </div>
</li>
