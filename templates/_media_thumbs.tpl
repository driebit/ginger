<div class="article_images container-fluid">
	{% with id.o.depiction as deps %}
	{% with id.o.hasdocument as docs %}
	
		{% if deps|length > 1 %}
			<div class="thumbnails row">
				
				{% for dep in deps %}
					{% if not forloop.first %}
						{% catinclude "_media_thumb.tpl" dep %}
					{% endif %}
				{% endfor %}

				{% for doc in docs %}
					{% catinclude "_media_thumb.tpl" doc %}
				{% endfor %}

			</div>
		{% endif %}

	{% endwith %}
	{% endwith %}



</div>