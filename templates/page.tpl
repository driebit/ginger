{% extends "base.tpl" %}

{% block page_class %}page{% endblock %}

{% block breadcrumb %}
{% endblock %}

{% block content %}
	
	{% with id.depiction as dep %}
	<div class="row {% block row_class %}{% endblock %}">

			{% block prev_next_nav %}{% endblock %}

			<article class="col-md-8">

					<h1>{{ id.title }}</h1>
				
					{% block page_depiction %}
                        {% if id.depiction %}
                            {% if dep.id.is_a.image %}
                                <a href="/image/{{ dep.id.medium.filename }}" class="lightbox" rel="fancybox-group">
                                    {% image id.depiction mediaclass="default" class="img-responsive" alt="" crop=id.depiction.id.crop_center %}
                                </a>
                            {% else %}
                                {# TODO: uploaded mp4 support #}
                                <div class="video-wrapper">
                                    {% media dep %}
                                </div>
                            {% endif %}
                        {% endif %}
                    {% endblock %}

					{% block page_summary %}
						{% if id.summary %}
							<p class="summary article_summary">{{ id.summary }}</p>
						{% endif %}
					{% endblock %}

					{% block page_body %}
						{% if id.body %}
							<div class="body article_body">{{ id.body|show_media }}</div>
						{% endif %}
					{% endblock %}
			
					{% block page_images %}
						{% include "_media_list.tpl" %}
					{% endblock %}
			
					{% block social_media %}{% endblock %}
				
			</article>
	
			<div class="col-md-4">
				{% catinclude "_aside.tpl" id %}
			</div>
		
	</div>
	{% endwith %}
{% endblock %}
