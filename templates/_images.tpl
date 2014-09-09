<div class="page_images container-fluid">
	{% with id.o.depiction as deps %}
		{% if deps|length > 1 %}
			<div class="thumbnails row">
				{% for dep in deps %}
					{% include "_image_thumb.tpl" id=dep %}
				{% endfor %}
			</div>
		{% endif %}
	{% endwith %}
</div>