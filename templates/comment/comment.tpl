{% with
    comment
as
    comment
%}

<li
  {% if comment.user_id == creator_id %}
    class="comment-author"
  {% else %}
    class="comment"
  {% endif %}
  {% if hidden %}
    style="display: none"
  {% endif %}
  id="comment-{{ comment.id }}">
  {% with m.rsc[comment.user_id] as user %}
    {% include "avatar/avatar.tpl" id=user %}
    <h3><a name="#comment-{{ comment.id }}"></a>{{ comment.name|default:user.title }}</h3>
  {% endwith %}
  <p class="comment__meta">{_ Posted _} {{ comment.created|timesince }}.</p>
  <p class="comment__body">{{ comment.message }}</p>
</li>

{% endwith %}
