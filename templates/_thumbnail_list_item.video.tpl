{% if id.is_visible and id.is_published %}
<li class="thumbnail col-lg-3 col-md-3">
    {% media id width=200 %}
	<p class="caption2"><span class="icon glyphicon glyphicon-camera"></span> <a href="{{ id.page_url }}">{{ id.summary|default:id.title|truncate:60 }}</a></p>
</li>
{% endif %}
