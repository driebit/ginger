{% if id.s.depiction %}
        {% with m.search[{ginger_search hasobject=[id,'depiction'] pagelen=6}] as result %}

            {% include "list/list-header.tpl" id=id list_title=_"Displayed in" items=result %}

            {% include "list/list.tpl" list_id="list--fixed-context" class="list--sided" items=result extraClasses="" id=id hide_showmore_button hide_showall_button %}

        {% endwith %}
{% endif %}


{% if id.subject %}
        {% with m.search[{query match_objects=id cat="media" is_published custompivot="ginger_search" filter=["is_unfindable", "false"] pagelen=6}] as result %}
            {% include "list/list-header.tpl" id=id list_title=_"Related" items=result %}

            {% include "keywords/keywords-aside.tpl" id=id items=result %}

            {% include "list/list.tpl" list_id="list--fixed-context" class="list--sided" items=result extraClasses="" id=id hide_showmore_button hide_showall_button %}
        {% endwith %}
{% endif %}
