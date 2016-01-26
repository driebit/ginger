            {% if id.o.fixed_context %}
                {% with m.search[{ginger_search hassubject=[id,'fixed_context'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Related" items=result %}

                    {% include "list/list.tpl" list_id="list--fixed-context" class="list--sided" items=result extraClasses="" id=id hide_showmore_button hide_showall_button %}

                {% endwith %}
            {% elif id.subject %}
                {% with m.search[{query match_objects=id is_published custompivot="ginger_search" filter=["is_unfindable", "false"] cat_exclude=['media', 'person'] pagelen=6}] as result %}

                    {% include "keywords/keywords-aside.tpl" id=id items=result %}

                    {% include "list/list.tpl" list_id="list--match-objects" items=result class="list--sided" extraClasses="" hide_showmore_button hide_showall_button id=id %}
                {% endwith %}
            {% endif %}
