        {% if id.s.author %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hasobject=[id,'author'] pagelen=6 sort='seq' }] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Authored by "++id.title items=result %}

                    {% include "list/list.tpl" list_id="list--authored" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

        {% if id.o.interest %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hassubject=[id,'interest'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Favorites of "++id.title items=result %}

                    {% include "list/list.tpl" list_id="list--favorited" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}
