{% with
    m.rsc[cat],
    m.rsc[predicate],
    title|default:m.rsc[predicate].title,
    tabs_enabled|default:['find'],
    tab|default:'find',
    actions|default:[],
    direction|default:'out',
    dispatch|default:zotonic_dispatch
as
    cat,
    predicate,
    title,
    tabs_enabled,
    tab,
    actions,
    direction,
    dispatch
%}

{% if id.is_editable %}
    <div class="ginger-edit__aside--{{ predicate.name }}">
        <h3 class="section-title">{{ title }}</h3>
        {% include "_ginger_connection_widget.tpl" predicate_ids=[predicate.id] %}
        {% include "_action_ginger_connection.tpl" category=cat.name predicate=predicate.name new_rsc_title=title tabs_enabled=tabs_enabled tab=tab direction=direction actions=actions dispatch=dispatch %}
    </div>
{% endif %}

{% endwith %}
