<div class="well">
<aside class="main-aside">

{% if page!="edit" %}
    {% if id.is_editable %}
        {% catinclude "_actions.tpl" id %}
    {% endif %}
{% endif %}

{% with m.rsc[id] as r %}

	{% if r.location_lat and r.location_lng %}
		{% include "geomap_small.tpl" %}
	{% endif %}

	{% if r.subject %}
		<h4>Keywords:</h4>
		<ul class="keywordlist">
		{% for keyw in r.subject %}
			<li><a href="{{ keyw.page_url }}">{{ m.rsc[keyw].title }}</a></li>
		{% endfor %}
		</ul>
	{% endif %}

	{% include "_ginger_edit_page_connections.tpl" %}
	{% include "_content_list.tpl" list=r.o.about title='About:'%}
	{% include "_content_list.tpl" list=r.s.stories title='About:'%}

	{% if r.o.fixed_context %}
		{% include "_fixed_context_list.tpl" list=r.o.fixed_context title='Similar pages:' %}
	{% elif r.subject %}
		{% include "_matched_context_list.tpl" id=id title='Similar pages:' %}
	{% endif %}

{% endwith %}

</aside>
</div>