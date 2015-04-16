<div class="page__content__comments__wrapper">
    <h3 class="page__content__comments__header">{{ comments|length }} reacties</h3>

    {% with m.comment.rsc[id] as comments %}
    {% if comments %}
    {% with m.rsc[id].creator_id as creator_id %}
    <ol class="page__content__comments">
        {% for comment in comments %}
           {% if comment.is_visible %}
               {% include "_comments_comment.tpl" %}
           {% endif %}
        {% endfor %}
    </ol>
    {% endwith %}
    {% endif %}
    {% endwith %}

    {% include "_comments_form.tpl" %}
</div>