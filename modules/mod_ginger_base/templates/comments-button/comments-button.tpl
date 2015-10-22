{% if m.modules.enabled|index_of:"mod_comment" %}
    <a href="#comments" class="comments-anchor do_anchor" id="comments-button">
        {_ comments: _} {{ m.comment.rsc[id]|length }} <i class="icon--arrow-down"></i>
    </a>
{% endif %}
