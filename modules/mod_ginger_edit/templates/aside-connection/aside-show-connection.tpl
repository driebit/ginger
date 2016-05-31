{% with
    title|default:m.rsc[predicate].title,
    direction|default:'in'
as
    title,
    direction
%}


    {# TODO styling #}

    {% if direction == 'in' %}
        {% if `mod_ginger_base`|member:m.modules.enabled %}
            {% with m.search[{query hassubject=[id, predicate|stringify] pagelen=6}] as result %}
                {% if result %}
                    <div class="ginger-edit__aside--{{ predicate }}">
                        <h3 class="section-title">{{ title }}</h3>
                        {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_edit_button hide_showmore_button hide_showall_button %}
                    </div>
                {% endif %}
            {% endwith %}
        {% else %}
                {% if id.s[predicate] %}
                    <div class="ginger-edit__aside--{{ predicate }}">
                        <h3 class="section-title">{{ title }}</h3>
                        {% optional include "_list.tpl" class="list-about" items=id.s[predicate] %}
                    </div>
                {% endif %}
        {% endif %}
    {% else %}
        {% if `mod_ginger_base`|member:m.modules.enabled %}
            {% with m.search[{query hasobject=[id, predicate|stringify] pagelen=6}] as result %}
                {% if result %}
                    <div class="ginger-edit__aside--{{ predicate }}">
                        <header><h3 class="section-title">{{ title }}</h3></header>
                        {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_button=1 %}
                    </div>
                {% endif %}
            {% endwith %}
        {% else %}
            {% if id.o[predicate] %}
                <div class="ginger-edit__aside--{{ predicate }}">
                    <header><h3 class="section-title">{{ title }}</h3></header>
                    {% optional include "_list.tpl" class="list-about" items=id.o[predicate] %}
                </div>
            {% endif %}
        {% endif %}
    {% endif %}
{% endwith %}
