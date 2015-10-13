<div class="page-actions">
    <div class="page-actions__author">
        {% include "person/person-author.tpl" id=id %}
    </div>
    {% include "share/share.tpl" %}
    {% include "page-actions/page-action-rsvp.tpl" %}
    {% if m.modules.enabled|index_of:"mod_comment" %}
        <div id="comments-button-wrapper">{% include "comments-button/comments-button.tpl" id=id %}</div>
    {% endif %}

    {% include "page-actions/page-action-edit-thing.tpl" %}
</div>
