{% with callback|default:q.callback|default:"window.zConnectDoneReload" as callback %}
    {% with m.rsc[cat].name as cat_name %}

    <ul class="nav nav-pills">
        {% block tabs %}

            {% if findtab!='false' and newtab!='false' %}
                <li {% if tab == "new" %}class="active"{% endif %}>
                    <a data-toggle="tab" href="#{{ #tab }}-new">{_ New Page _}</a>
                </li>

                <li {% if tab == "find" and not q.is_zmedia %}class="active"{% endif %}>
                    <a data-toggle="tab" data-id="{{m.rsc[cat_name].id}}" data-name="{{cat_name}}" href="#{{ #tab }}-find">{_ Find Page _}</a>
                </li>
            {% endif %}

        {% endblock %}
    </ul>

    <div class="tab-content" id="dialog-connect-panels">
        {% block tabs_content %}

            {% if direction=='in' %}
                {% if newtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate objects=[[object_id, predicate]] title=""
                            is_active=1 cat=cat callback="" %}
                {% endif %}
                {% if findtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate objects=[[object_id, predicate]] redirect=redirect
                            is_active=(newtab == 'false') title="" cat=cat callback=callback %}
                {% endif %}
            {% else %}
                {% if newtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate subject_id=subject_id title=""
                            is_active=1 cat=cat callback="" %}
                {% endif %}
                {% if findtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate subject_id=subject_id redirect=redirect
                            is_active=(newtab == 'false') title="" cat=cat callback=callback %}
                {% endif %}
            {% endif %}

        {% endblock %}
    </div>

    {% endwith %}
{% endwith %}