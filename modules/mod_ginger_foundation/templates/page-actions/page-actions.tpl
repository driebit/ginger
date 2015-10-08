<div class="page-actions">
    <div class="page-actions__author">
        {% include "person/person-author.tpl" id=id %}
    </div>
    {% include "share/share.tpl" %}

    <div id="comments-button-wrapper">{% include "comments-button/comments-button.tpl" id=id %}</div>

    {% include "page-actions/page-action-add-thing.tpl" %}
    {% include "page-actions/page-action-edit-thing.tpl" %}
</div>
