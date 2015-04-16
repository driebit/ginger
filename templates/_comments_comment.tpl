<li class="page__content__comment">
    <div class="page__content__comment__about">
        {{ comment.name|default:m.rsc[comment.user_id].title }}<br/>
        {{ comment.created|date:"j F Y G:i:s" }}<br/>
    </div>

    {{ comment.message }}
</li>