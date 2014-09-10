{% extends "base.tpl" %}

{% block page_class %}home{% endblock %}

{% block content %}
	<div class="row">
		<div class="col-md-8">
			{% include "_carousel.tpl" 
				items=m.rsc.home_set.haspart 
				carousel="carousel" 
				pager="carousel-pager"
			%}

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

			{% include "_list.tpl" cols="2" items=m.rsc.home_set.haspart %}
		</div>

		<aside class="col-md-4">
			{% include "_list.tpl" cols="1" items=m.search[{latest cat="article" pagelen=5}] %}
		</aside>
	</div>
{% endblock %}

