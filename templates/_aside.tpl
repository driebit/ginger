<div class="well">
<aside class="main-aside">

{% if page!="edit" %}
    {% if id.is_editable %}
        {% catinclude "_actions.tpl" id %}
    {% endif %}
{% endif %}

{% with m.rsc[id] as r %}

    {% with r.subject as keywords %} 
        {% if keywords %}
           {% include "_list.tpl" title="Keywords" class="keywords" items=r.subject %}
        {% endif %}
    {% endwith %}

	{% include "_content_list.tpl" list=r.o.about title='About:'%}
    {% include "_ginger_edit_page_connections.tpl" %}

    {% if r.o.fixed_context %}
        {% include "_fixed_context_list.tpl" list=r.o.fixed_context %}
    {% elif r.subject %}
        {% catinclude "_matched_context_list.tpl" id %}
    {% else %}
        {% catinclude "_default_context_list.tpl" id %}
    {% endif %}

{% endwith %}

</aside>
</div>