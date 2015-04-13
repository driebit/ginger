{% extends "base.tpl" %}

{% block page_class %}page{% endblock %}

{% block breadcrumb %}
{% endblock %}

{% block content %}

<p>{{ m.rsc[id]['http://purl.org/dc/elements/1.1/creator'] }}</p>
<p>{{ m.rsc[id]['dc:creator'] }}</p>
<p>{{ m.rsc[id]['dc:description'] }}</p>
<p>{{ m.rsc[id]['dcterms:created'] }}</p>
<p>{{ m.rsc[id]['dc:date'] }}</p>
<p>{{ m.rsc[id]['dc:format'] }}</p>
<p>{{ m.rsc[id]['dc:rights'] }}</p>
<p><a href="{{ m.rsc[id].uri }}">{{ id.uri }}</a></p>

{% for key, val in m.rsc[id] %}
{% if key == "ese:isShownBy" %}
<img src="{{ val }}.jpg">
{% endif %}
{% endfor %}


	{% with id.depiction as dep %}
	<div class="row {% block row_class %}{% endblock %}">

		{% block prev_next_nav %}{% endblock %}

		<article class="col-md-8">
            
            {% block page_actions %}{% catinclude "_page_actions.tpl" id %}{% endblock %}

			<h1>{{ id.title }}</h1> 
		
			{% block page_depiction %}
                {% if id.depiction %}
                    {% if dep.id.is_a.image %}
                        <a href="/image/{{ dep.id.medium.filename }}" class="lightbox" rel="fancybox-group">
                            {% image id.depiction mediaclass="default" class="img-responsive" alt="" crop=id.depiction.id.crop_center %}
                        </a>
                    {% else %}
                        {% if id.is_a.document %}
                            {% catinclude "_media_item.tpl" id %}
                        {% else %}
                            <a href="{{ dep.id.page_url }}">
                                {% include "_media_item.tpl" id=id %}
                            </a>
                        {% endif %}
                    {% endif %}
                {% endif %}
            {% endblock %}

			{% block page_summary %}
				{% if id.summary %}
					<p class="summary article_summary">{{ id.summary }}</p>
				{% endif %}
			{% endblock %}

			{% block page_date %}
				{% if id.date_start %}<p class="date">{{ id.date_start }}{% endif %}
				{% if id.date_end %} - {{ id.date_end }}{% endif %}
				{% if id.date_start %}</p>{% endif %}
			{% endblock %}

			{% block page_body %}
				{% if id.body %}
					<div class="body article_body">{{ id.body|show_media }}</div>
				{% endif %}
			{% endblock %}
	
			{% block page_blocks %}
				{% include "_blocks.tpl" %}
			{% endblock %}

			{% block page_images %}
				{% include "_media_list.tpl" %}
			{% endblock %}
	
			{% block content_connections %}{% endblock %}

			{% block social_media %}
				{% optional include "_action_share_page.tpl" %}
            {% endblock %}

             {% block comments %}
                {% optional include "_comments.tpl" %}
            {% endblock %}
			
		</article>

		<div class="col-md-4">
			{% catinclude "_aside.tpl" id %}
		</div>
	</div>
	{% endwith %}
{% endblock %}
