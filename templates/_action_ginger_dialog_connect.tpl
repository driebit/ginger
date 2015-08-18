{% with callback|default:q.callback|default:"window.zConnectDoneReload" as callback %}
    {% with m.rsc[cat].name as cat_name %}

    <ul class="nav nav-pills">
        {% block tabs %}

        {% if cat_name!='keyword' %}
            {% if findtab!='false' and newtab!='false' %}
                <li {% if tab == "new" %}class="active"{% endif %}>
                    <a data-toggle="tab" href="#{{ #tab }}-new">{_ New Page _}</a>
                </li>

                <li {% if tab == "find" and not q.is_zmedia %}class="active"{% endif %}>
                    <a data-toggle="tab" data-id="{{m.rsc[cat_name].id}}" data-name="{{cat_name}}" href="#{{ #tab }}-find">{_ Find Page _}</a>
                </li>
            {% endif %}
        {% else %}
            {% if m.category[123].tree1 %}
                <li {% if tab == "keyword" %}class="active"{% endif %}>
                    <a data-toggle="tab" data-id="{{m.rsc["keyword"].id}}" data-name="keyword" href="#{{ #tab }}-keyword" id='tab-button-keyword'>{_ All _}</a>
                </li>
                {% for child in m.category[123].tree1 %}
                    {% with m.rsc[child.id].name as name %}
                    <li {% if tab == "{{ name }}" %}class="active"{% endif %}>
                        <a data-toggle="tab" data-id="{{m.rsc[name].id}}" data-name="{{name}}" href="#{{ #tab }}-{{ name }}" id='tab-button-{{ name }}'>{{ m.rsc[name].title }}</a>
                    </li>
                    {% endwith %}
                {% endfor %}
            {% endif %}
        {% endif %}

        {% endblock %}
    </ul>

    <div class="tab-content" id="dialog-connect-panels">
        {% block tabs_content %}

            {% if direction=='in' %}
                {% if newtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate objects=[[object_id, predicate]] title=""
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'new') cat=cat callback="" %}
                {% endif %}
                {% if findtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate objects=[[object_id, predicate]] redirect=redirect
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'find') title="" cat=cat callback=callback %}
                {% endif %}
            {% else %}
                {% if newtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate subject_id=subject_id title=""
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'new') cat=cat callback="" %}
                {% endif %}
                {% if findtab!='false' %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate subject_id=subject_id redirect=redirect
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'find') title="" cat=cat callback=callback %}
                {% endif %}
            {% endif %}

        {% endblock %}
    </div>

    {% endwith %}
{% endwith %}