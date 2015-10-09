<div class="page-actions">
    <div class="page-actions__author">
        {% include "person/person-author.tpl" id=id %}
    </div>
    {% include "share/share.tpl" %}
    {% include "page-actions/page-action-rsvp.tpl" %}
    {% include "comments-button/comments-button.tpl" id=id %}

    {% include "page-actions/page-action-edit-thing.tpl" %}
</div>
