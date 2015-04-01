{% comment %} 
This override can be removed when https://github.com/zotonic/zotonic/pull/933 
has been merged and tagged.
{% endcomment %}
<div class="rsc-item" id="{{ #item }}">
    {% with id.depiction as depict %}
    	{% image depict mediaclass="admin-list-overview" class="thumb pull-left" %}
    {% endwith %}
    <strong><a href="{% url admin_edit_rsc id=id %}">{{ id.title }}</a></strong><br />
	<span class="text-muted">{{ id|summary:50 }}</span>
</div>
