<div id="comments" class="page__content__comments__wrapper">
    <h3 class="page__content__comments__header">{{ comments|length }} reacties</h3>
    <ol class="page__content__comments" id="comments-list">
    {% with m.comment.rsc[id] as comments %}
        {% if comments %}
            {% with m.rsc[id].creator_id as creator_id %}
                
                    {% for comment in comments %}
                        {% if comment.is_visible %}
                           {% include "_comments_comment.tpl" %}
                       {% endif %}
                    {% endfor %}
                
            {% endwith %}
        {% endif %}
    {% endwith %}
    </ol>
    {% include "_comments_form.tpl" %}
</div>
