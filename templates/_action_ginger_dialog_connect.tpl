{% with callback|default:q.callback|default:"window.zAdminConnectDone" as callback %}

<ul class="nav nav-pills">
    {% block tabs %}

        <li {% if tab == "new" %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-new">{_ New Page _}</a>
        </li>

        <li {% if tab == "find" and not q.is_zmedia %}class="active"{% endif %}>
            <a data-toggle="tab" href="#{{ #tab }}-find">{_ Find Page _}</a>
        </li>

	{% endblock %}
</ul>

<div class="tab-content" id="dialog-connect-panels">
    {% block tabs_content %}

        {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate subject_id=subject_id title=""
                    is_active=1 %}

        {% include "_action_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate subject_id=subject_id redirect=redirect
                    is_active=0 title="" cat=cat|default:(m.predicate.object_category[predicate]|first|element:1) callback=callback %}

    {% endblock %}
</div>

{% endwith %}