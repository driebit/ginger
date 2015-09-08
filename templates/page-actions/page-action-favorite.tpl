{% if m.acl.user %}
    {% with m.acl.user as subject_id %}
    {% with id.id as object_id %}
        {% optional include "_action_like.tpl" subject_id=m.acl.user.id predicate='interest' object_id=id edge_template='_action_like.tpl' btn_class='btn--default' btn_like_text='Favoriet' btn_unlike_text='Favoriet' %}
    {% endwith %}
    {% endwith %}
{% endif %}
