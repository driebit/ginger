{% with callback|default:(dispatch=="ginger_edit")|if:"zAdminConnectDone":"window.zConnectDoneReload" as callback %}
{% with tabs_enabled|default:((dispatch=="ginger_edit")|if:["find"]:["find","new"]) as tabs_enabled %}
{% with actions|default:[] as actions %}
{% with stay or callback or subject_id as stay %}
{% with tabs_enabled|first|default:"find" as firsttab %}
{% with tab|default:firsttab as tab %}
{% with m.rsc[cat].name as cat_name %}

    <ul class="nav nav-pills">
        {% block tabs %}
        {% if cat_name!='keyword' %}
            {% if not (tabs_enabled and tabs_enabled|length == 1) %}
                {% if "new"|member:tabs_enabled %}
                    <li {% if tab == "find" %}class="active"{% endif %}>
                        <a data-toggle="tab" data-id="{{m.rsc[cat_name].id}}" data-name="{{cat_name}}" href="#{{ #tab }}-find">{_ Find Page _}</a>
                    </li>
                {% endif %}
                {% if "find"|member:tabs_enabled %}
                    <li {% if tab == "new" %}class="active"{% endif %}>
                        <a data-toggle="tab" href="#{{ #tab }}-new">{_ New Page _}</a>
                    </li>
                {% endif %}
            {% endif %}
        {% else %}
            {% if "find"|member:tabs_enabled %}
                {% with m.category[m.rsc.keyword.id].tree1 as hassubs %}
                <li {% if tab == "find" %}class="active"{% endif %}>
                    <a data-toggle="tab" data-id="{{m.rsc["keyword"].id}}" data-name="keyword" href="#{{ #tab }}-find" id='tab-button-keyword'>{% if hassubs %}{_ All _}{% else %}{_ Find _}{% endif %}</a>
                </li>
                {% if hassubs %}
                    {% for child in m.category[m.rsc.keyword.id].tree1 %}
                        {% with m.rsc[child.id].name as name %}
                        <li {% if tab == "{{ name }}" %}class="active"{% endif %}>
                            <a data-toggle="tab" data-id="{{m.rsc[name].id}}" data-name="{{name}}" href="#{{ #tab }}-find" id='tab-button-{{ name }}'>{{ m.rsc[name].title }}</a>
                        </li>
                        {% endwith %}
                    {% endfor %}
                {% endif %}
                {% endwith %}
            {% endif %}
            {% if m.acl.insert[cat_name] and "new"|member:tabs_enabled %}
                <li {% if tab == "new" %}class="active"{% endif %}>
                    <a data-toggle="tab" href="#{{ #tab }}-new">{_ New _}</a>
                </li>
            {% endif %}
        {% endif %}

        {% endblock %}
    </ul>

    <div class="tab-content" id="dialog-connect-panels">
        {% block tabs_content %}

            {% if direction=='in' %}
                {% if "new"|member:tabs_enabled %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate objects=[[object_id, predicate]]++objects title=""
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'new') cat=cat callback="" actions=actions redirect=1 %}
                {% endif %}
                {% if "find"|member:tabs_enabled %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate object_id=object_id redirect=redirect
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'find') title="" cat=cat callback=callback actions=actions %}
                {% endif %}
            {% else %}
                {% if "new"|member:tabs_enabled %}
                    {% include "_action_ginger_dialog_connect_tab_new.tpl" tab=#tab predicate=predicate subject_id=subject_id objects=objects title=""
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'new') cat=cat callback="" actions=actions redirect=1 %}
                {% endif %}
                {% if "find"|member:tabs_enabled %}
                    {% include "_action_ginger_dialog_connect_tab_find.tpl" tab=#tab predicate=predicate subject_id=subject_id redirect=redirect
                            cg_id=cg_id nocatselect=nocatselect is_active=(tab == 'find') title="" cat=cat callback=callback actions=actions %}
                {% endif %}
            {% endif %}

        {% endblock %}
    </div>

{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
{% endwith %}
