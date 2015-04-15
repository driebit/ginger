<div class="page__content__comments__wrapper">
    <h3 class="page__content__comments__header">{{ comments|length }} reacties</h3>

    <ol class="page__content__comments">
        {% for comment in comments %}
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

                        {{ comment.o.author.first_name }} {{ comment.o.author.last_name }}<br/>
                    {% endif %}

                    {{ comment.publication_start|date:"j F Y G:i:s" }}<br/>
                </div>

                {{ comment.body }}
            </li>
        {% endfor %}
    </ol>
</div>
