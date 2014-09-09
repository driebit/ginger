{% extends "base.tpl" %}

{% block page_class %}home{% endblock %}

{% block content %}
	<div class="row">
		<div class="col-md-8">
			<article class="home-article">
				{% with m.rsc.home_article as home %}
					{% block title %}
						<h2 class="title home_title">{{ home.title }}</h2>
					{% endblock %}

					{% block body %}
						{% if home.body %}
							<div class="body home_body">{{ home.body|show_media }}</div>
						{% endif %}
					{% endblock %}
				{% endwith %}
			</article>

			<ul class="home-set list list-image row">
				{% for id in m.rsc.home_set.haspart %}
					{% catinclude "_list_item_image.tpl" id class="col-xs-12 col-sm-6" %}
				{% endfor %}
			</ul>
		</div>

		<aside class="col-md-4">
			sidebar
		</aside>
	</div>
{% endblock %}

