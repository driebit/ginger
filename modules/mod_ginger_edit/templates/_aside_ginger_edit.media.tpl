<aside>

    {% if id.is_editable %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="keyword" predicate="subject" %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="person" predicate="author" title=_'Author' %}
    {% endif %}
	
    {% include "aside-connection/aside-show-connection.tpl" id=id predicate="depiction" title=_"On page" %}

</aside>