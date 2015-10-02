{% with
    m.rsc[cat],
    m.rsc[predicate],
    title|default:m.rsc[predicate].title,
    newtab|default:'false'

as
    cat,
    predicate,
    title,
    newtab
%}

{% if id.is_editable %}
    <div class="ginger-edit__aside--{{ predicate.name }}">
        <h3 class="section-title">{{ title }}</h3>

        {% include "_ginger_connection_widget.tpl" predicate_ids=[predicate.id] %}

        {% include "_action_ginger_connection.tpl" callback='zAdminConnectDone' newtab=newtab category=cat.name predicate=predicate.name new_rsc_title=title tab='find' %}
    </div>
{% endif %}

{% endwith %}
