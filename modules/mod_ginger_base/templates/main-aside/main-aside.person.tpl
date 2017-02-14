        {% if id.s.author %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hasobject=[id,'author'] cat_exclude=m.modules.enabled|index_of:"mod_ginger_remark"|if:"remark":"" pagelen=6 sort='-rsc.modified'}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Authored by "++id.title items=result %}

                    {% include "list/list.tpl" list_id="list--authored" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

        {% if id.o.interest %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hassubject=[id,'interest'] pagelen=6 sort='-rsc.modified'}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Favorites of "++id.title items=result %}

                    {% include "list/list.tpl" list_id="list--favorited" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

        {% if m.modules.enabled|index_of:"mod_ginger_remark" %}
            {% with m.search[{ginger_search cat="remark" hasobject=[id,'author'] pagelen=6 sort='-rsc.modified'}] as result %}

                {% if result %}

                    <aside class="main-aside">

                        {% include "list/list-header.tpl" id=id list_title=_"Remarks of "++id.title items=result %}

                        {% include "list/list.tpl" list_id="list--remarks" items=result extraClasses="" id=id %}
                    </aside>

                {% endif %}

            {% endwith %}
        {% endif %}
