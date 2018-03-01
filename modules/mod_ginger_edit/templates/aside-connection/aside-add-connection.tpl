{% with
    m.rsc[cat],
    predicate|as_atom,
    m.rsc[predicate],
    title|default:m.rsc[predicate].title,
    tabs_enabled|default:['find'],
    tab|default:'find',
    actions|default:[],
    direction|default:'out',
    dispatch|default:zotonic_dispatch,
    helper_text_top,
    errormsg_required|default:_"Field is required"
as
    cat,
    predicate_name,
    predicate,
    title,
    tabs_enabled,
    tab,
    actions,
    direction,
    dispatch,
    helper_text_top,
    errormsg_required
%}
{% if id.is_editable %}

    <div id="{{ #thepredicate }}" class="ginger-edit__aside--{{ predicate_name }}" {% if required %} data-errormessage="{{ errormsg_required }}"{% endif %}>
        {% block aside_connection_title %}
            <h3 class="section-title">{{ title }}</h3>
        {% endblock %}

        {% if helper_text_top %}<p class="helper-text">{{ helper_text_top }}</p>{% endif %}

        {% if preset_id %}{% include "aside-connection/aside-show-line.tpl" id=preset_id %}{% endif %}

        {% include "_ginger_connection_widget.tpl" predicate_ids=[predicate.id] direction=direction %}

        {% include "_action_ginger_connection.tpl" category=cat.name predicate=predicate_name new_rsc_title=title tabs_enabled=tabs_enabled tab=tab direction=direction actions=actions dispatch=dispatch %}

        <div class="form-group">
            <input type="hidden" id="{{ #predicate}}_{{ predicate_name }}" value="0" />
        </div>

        {% if required %}
            {% validate id=#predicate++"_"++predicate_name type={presence failure_message=errormsg_required} type={custom against="window.has_connection" failure_message=errormsg_required args=#thepredicate } only_on_submit %}
        {% endif %}

    </div>
{% endif %}

{% endwith %}
