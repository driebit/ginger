<div class="page-actions">
    <div class="page-actions__author">
        {% catinclude "person/person-author.tpl" id %}
    </div>
    {% catinclude "share/share.tpl" id %}
    {% catinclude "page-actions/page-action-rsvp.tpl" id %}
    {% if m.modules.enabled|index_of:"mod_comment" %}
        <div id="comments-button-wrapper">{% catinclude "comments-button/comments-button.tpl" id %}</div>
    {% endif %}

    {% catinclude "page-actions/page-action-edit-thing.tpl" id %}
</div>
