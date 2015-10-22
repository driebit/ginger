{% with
    title|default:m.rsc[predicate].title,
    direction|default:'in'
as
    title,
    direction
%}

<div class="ginger-edit__aside--{{ predicate }}">
    {# TODO styling #}<br/>

    {% if direction == 'in' %}
        {% if `mod_ginger_base`|member:m.modules.enabled %}
            {% with m.search[{query hassubject=[id, predicate|stringify] pagelen=6}] as result %}
                {% if result %}
                    <h3 class="section-title">{{ title }}</h3>
                    {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_edit_button hide_showmore_button hide_showall_button %}
                {% endif %}	
            {% endwith %}
        {% else %}
            <section class="aside_block aside_{{ predicate }}">
                {% if id.s[predicate] %}
                    <h3 class="section-title">{{ title }}</h3>
                    {% optional include "_list.tpl" class="list-about" items=id.s[predicate] %}
                {% endif %}	
            </section>
        {% endif %}	
    {% else %}
        {% if `mod_ginger_base`|member:m.modules.enabled %}
            {% with m.search[{query hasobject=[id, predicate|stringify] pagelen=6}] as result %}
                 {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_button=1 %}
            {% endwith %}
        {% else %}
            <section class="aside_block aside_{{ predicate }}">
                {% if id.o[predicate] %}
                    <header><h3 class="section-title">{{ title }}</h3></header>
                    {% optional include "_list.tpl" class="list-about" items=id.o[predicate] %}
                {% endif %}	
            </section>
        {% endif %}	
    {% endif %}

</div>

{% endwith %}
