{% extends "base.tpl" %}

{% block page_class %}timeline{% endblock %}

{% block container_class %}container{% endblock %}

{% block content %}
	{% block timeline_title %}
		<h2 class="page-header">{{ id.title }}</h2>
	{% endblock %}
	
	{% block page_content %}
		<div id="my-timeline"></div>
	{% endblock %}

{% endblock %}

{% block module_script %}

    {% lib
        "js/storyjs-embed.js"
    %}

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

                            {% if dep %}
                                "media":"{% image_url dep mediaclass="list-image" alt=id.title class="img-responsive" crop=dep.id.crop_center %}",
                            {% endif %}
                            "credit":"",
                            "thumbnail":"{% image_url dep mediaclass="thumbnail" alt=id.title class="img-responsive" crop=dep.id.crop_center %}",
                            "caption":""
                        }
                        {% endwith %}
                    },
                {% endfor %}
                ]
            }
        }    
        
    	createStoryJS({
    		type:                 'timeline',
            lang:                 '{{ z_language }}',
    		width:                '100%',
    		height:               '600',
            js:                   '/lib/js/timeline.js',
            css:                  '/lib/css/timeline.css',
    		source:               dataObject,
    		embed_id:             'my-timeline',
            start_zoom_adjust:    {{ id.timelinezoom|default:"-2" }}
    	});

        /* Safari fix */
        setTimeout(function(){
            $(window).trigger('resize');
        }, 100);

    {% endjavascript %}


{% endblock %}

