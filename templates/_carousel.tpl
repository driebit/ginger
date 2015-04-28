{% if items %}

	{% block carousel %}
		<ul id="{{ carousel }}" class="carousel {{ class }}">
			{% for id in items %}
				{% if itemtemplate %}
					{% include itemtemplate id=id %}
				{% else %}
					{% catinclude "_carousel_item.tpl" id %}
				{% endif %}
			{% endfor %}
		</ul>
	{% endblock %}

	{% block pager %}
		<ul id="{{ pager }}" class="carousel-pager">
			{% for id in items %}
				{% with id.depiction as dep %}

					{% if pagertemplate %}
						{% include pagertemplate id=id counter=forloop.counter0 %}
					{% else %}
						<li class="carousel-pager_item">
							<a data-slide-index="{{ forloop.counter0 }}" href=""> 
								{% if m.media[id].preview_filename %}
									{% image m.media[id].preview_filename mediaclass="pager-image" alt=id.title %}
								{% else %}
									{% image id.depiction mediaclass="pager-image" alt=id.title %}
								{% endif %}
							</a>
						</li>
					{% endif %}

				{% endwith %}
			{% endfor %}
		</ul>
	{% endblock %}

	{% javascript %}
		var slider = new mod_bxslider({
			container: '#{{ carousel }}',
			pagerCustom: '#{{ pager }}',
			pause: 6000,
			auto: true,
			controls: {% if controls %}{{ controls }} {% else %} true {% endif %}
		});
	{% endjavascript %}

{% endif %}