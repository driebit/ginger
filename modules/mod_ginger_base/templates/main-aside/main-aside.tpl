{% if id.o.fixed_context %}
    <aside class="main-aside">
        {% with m.search[{ginger_search hassubject=[id,'fixed_context'] pagelen=6}] as result %}

            {% include "list/list-header.tpl" id=id list_title=_"Related" items=result %}

            {% include "list/list.tpl" list_id="list--fixed-context" items=result extraClasses="" id=id %}

        {% endwith %}
    </aside>
{% elif id.subject %}
    <aside class="main-aside">
        {% with m.search[{query match_objects=id is_published custompivot="ginger_search" filter=["is_unfindable", "false"] cat_exclude=['media', 'person'] pagelen=6}] as result %}
            {% include "list/list-header.tpl" id=id list_title=_"Related" items=result %}

            {% include "keywords/keywords.tpl" id=id items=result %}

            {% include "list/list.tpl" list_id="list--match-objects" items=result extraClasses="" id=id %}
        {% endwith %}
    </aside>
{% endif %}
