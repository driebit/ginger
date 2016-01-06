
{% if id.s.presented_at %}
    <aside class="main-aside">
        {% with m.search[{ginger_search hasobject=[id,'presented_at'] pagelen=6}] as result %}

            {% include "list/list-header.tpl" id=id list_title=_"Events" items=result %}

            {% include "list/list.tpl" list_id="list--fixed-context" items=result extraClasses="" id=id %}

        {% endwith %}
    </aside>
{% endif %}

{% if id.s.located_in %}
    <aside class="main-aside">
        {% with m.search[{ginger_search hasobject=[id,'located_in'] pagelen=6}] as result %}

            {% include "list/list-header.tpl" id=id list_title=_"Located here" items=result %}

            {% include "list/list.tpl" list_id="list--fixed-context" items=result extraClasses="" id=id %}

        {% endwith %}
    </aside>
{% endif %}
