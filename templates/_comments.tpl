<div class="page__content__comments__wrapper">
    <h3 class="page__content__comments__header">{{ comments|length }} reacties</h3>

    <ol class="page__content__comments">
        {% for comment in comments %}
            <li class="page__content__comment">
                <div class="page__content__comment__about">
                    {% if comment.o.author %}
                        {{ comment.o.author.first_name }} {{ comment.o.author.last_name }}<br/>
                    {% endif %}

                    {{ comment.publication_start|date:"j F Y G:i:s" }}<br/>
                </div>

                {{ comment.body }}
            </li>
        {% endfor %}
    </ol>
</div>
