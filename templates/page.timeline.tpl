{% extends "base.tpl" %}

{% block page_class %}timeline{% endblock %}

{% block content %}
	{% block page_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}
	
	{% block page_content %}
		<div id="my-timeline"></div>
	{% endblock %}
{% endblock %}




{% block module_script %}

<script type="text/javascript" src="http://cdn.knightlab.com/libs/timeline/latest/js/storyjs-embed.js"></script>

{% javascript %}
    var dataObject = {
    "timeline":
    {
        "headline":"{{ id.title }}",
        "type":"default",
		"text":"{{ id.summary }}",
		"startDate":"1980,1,1",
        "date": [
		{% for pid in id.o.haspart %}

            {
                "startDate":"{{ pid.date_start|date:"Y,m,d" }}",
                {% if pid.date_end %}"endDate":"{{ pid.date_end|date:"Y,m,d" }}",{% endif %}
                "headline":"<a href='{{ pid.page_url }}' style='text-decoration: none;'>{{ pid.title }}</a>",
                "text":"<p><a href='{{ id.page_url }}' style='text-decoration: none;'>{{ pid.summary }}</a></p>",
                {% with pid.depiction as dep %}
                "asset":
                {
                    "media":"{% image_url dep mediaclass="list-image" alt=id.title class="img-responsive" crop=id.depiction.id.crop_center %}",
                    "credit":"",
                    "caption":""
                }
                {% endwith %}
            },
        {% endfor %}
        ]
    }
    }    
    
	createStoryJS({
		type:       'timeline',
		width:      '100%',
		height:     '600',
		source:     dataObject,
		embed_id:   'my-timeline'
	});
{% endjavascript %}


{% endblock %}

