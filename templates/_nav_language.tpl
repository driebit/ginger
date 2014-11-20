{% with m.translation.language_list_enabled as languages %}
	{% if languages and languages[2]%}
		<div class="btn-group navbar-btn navbar-right nav-language">
			<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
				{{ z_language }} <span class="caret"></span>
			</button>
			<ul class="dropdown-menu" role="menu">
				{% for code,lang in languages %}
					{% if all or lang.is_enabled %}
						<li><a href="{% url language_select code=code p=m.req.raw_path %}">{{ code }}</a></li>
					{% endif %}
				{% endfor %}
			</ul>
		</div>
	{% endif %}
{% endwith %}
