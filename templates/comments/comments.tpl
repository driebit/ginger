{% with m.comment.rsc[id] as comments %}
  <div class="comments">
      <h3 class="comments__header">{{ comments|length }} reacties</h3>
          {% if comments %}
              {% with m.rsc[id].creator_id as creator_id %}
                  <ul id="comments-list" class="comments__list">
                      {% for comment in comments %}
                          {% if comment.is_visible %}
                             {% include "comment/comment.tpl" comment=comment%}
                         {% endif %}
                      {% endfor %}
                  </ul>
              {% endwith %}
          {% endif %}

      {% include "comments/_comments_form.tpl" %}
  </div>
{% endwith %}
