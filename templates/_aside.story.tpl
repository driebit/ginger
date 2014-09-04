<div class="well">
<aside class="main-aside">

{% with m.rsc[id] as r %}

    {% with r.subject as keywords %} 
        {% if keywords %}
           {% include "_button_list.tpl" title="Keywords" class="keywords" items=r.subject %}
        {% endif %}
    {% endwith %}

	{% include "_ginger_edit_page_connections.tpl" %}
	{% include "_content_list.tpl" list=r.o.about title='About:'%}
	{% include "_content_list.tpl" list=r.s.hasstory title='About:'%}

	{% if r.o.fixed_context %}
		{% include "_fixed_context_list.tpl" list=r.o.fixed_context title='Similar pages:' %}
	{% elif r.subject %}
		{% include "_matched_context_list.tpl" id=id title='Similar pages:' %}
	{% endif %}

{% endwith %}

</aside>
</div>