<li class="comment" {% ifequal comment.user_id creator_id %}{% endifequal %} {% if hidden %}style="display: none"{% endif %} id="comment-{{ comment.id }}">
    {% with m.rsc[comment.user_id].depiction as dep %}
        {% if dep %}
            {% image dep mediaclass="comment-avatar" alt=" " crop=id.depiction.id.crop_center %}            
        {% endif %}
    {% endwith %}
    <div class="comment_content">
        <h3><a name="#comment-{{ comment.id }}"></a>{{ comment.name|default:m.rsc[comment.user_id].title }}</h3>
        <p class="comment_meta">{_ Posted _} <time datetime="{{comment.created}}">{{ comment.created|timesince }}</time>.</p>
        <p class="comment_body">{{ comment.message }}</p>
    </div>
</li>
