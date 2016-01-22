{% with
    m.rsc[cat],
    m.rsc[predicate],
    title|default:m.rsc[predicate].title,
    tabs_enabled|default:['find'],
    tab|default:'find',
    actions|default:[],
    direction|default:'out',
    dispatch|default:zotonic_dispatch,
    required|default:"false"
as
    cat,
    predicate,
    title,
    tabs_enabled,
    tab,
    actions,
    direction,
    dispatch,
    required
%}

{% if id.is_editable %}
    <div id="{{ #thepredicate }}" class="ginger-edit__aside--{{ predicate.name }}">
        <h3 class="section-title">{{ title }}</h3>
        {% include "_ginger_connection_widget.tpl" predicate_ids=[predicate.id] %}
        {% include "_action_ginger_connection.tpl" category=cat.name predicate=predicate.name new_rsc_title=title tabs_enabled=tabs_enabled tab=tab direction=direction actions=actions dispatch=dispatch %}
        
        {% if required == "true" %}
        
            <input type="hidden" id="{{ #predicate.name }}" value="0" />
        
            {% validate id=#predicate.name type={presence failure_message=_"Field is required"} type={custom against="window.has_connection" failure_message=_"Field is required" args=#thepredicate } only_on_submit %}
            
        {% endif %}    

    </div>
{% endif %}

{% endwith %}
