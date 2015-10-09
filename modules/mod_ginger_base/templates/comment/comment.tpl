{% with
    comment
as
    comment
%}

<li id="comment-{{ comment.id }}"
    {% if comment.user_id == creator_id %}
        class="comment--author"
    {% else %}
        class="comment"
    {% endif %}
    {% if hidden %}
    s   tyle="display: none"
    {% endif %}>
        {% with m.rsc[comment.user_id] as user %}
            <div class="comment__about">
                {% include "avatar/avatar.tpl" id=user %}
                <h3><a name="#comment-{{ comment.id }}"></a>{{ comment.name|default:user.title }}</h3>
                <p class="comment__meta">{{ comment.created|timesince }}.</p>
            </div>
        {% endwith %}
    <p class="comment__body">{{ comment.message }}</p>
</li>

{% endwith %}
