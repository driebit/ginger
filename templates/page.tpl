{% extends "base.tpl" %}

{% block body_class %}page{% endblock %}

{% block content %}
    <div class="l-container">
        <div class="l-content">
            
        </div>
        <div class="related">
            <div class="list">
                <div class="list__item"></div>
            </div>
        </div>
    </div>


    {#
	<div class="row {% block row_class %}{% endblock %}">

		{% block prev_next_nav %}{% endblock %}

		<article class="col-md-8">
            
            {% block author_date_share_edit %}
                
                <div class="row" class="author_date_share_row">
                    <div class="col-xs-10">
                        <div class="center-inline-block clearfix author-date-share">
                            
                          {% include "_author.tpl" id=id prefix %}
                          {% if id.publication_start %}<span> {_ op _} {{ id.modified|date:"j F Y" }}</span>{% endif %}
                        </div>
                    </div>
                    <div class="col-xs-2 clearfix">
                        {% include "_sharing_foldout.tpl" %}
                        {% include "_nav_edit.tpl" extraClasses="button-edit pull-right" %}
                    </div>

                </div>

            {% endblock %}

			<h1>{{ id.title }}</h1> 

            {% block page_date %}
                {% include "_date.tpl" id=id %}
            {% endblock %}

            {% block page_actions %}
                <div class="page-actions clearfix">
                    {% catinclude "_page_actions.tpl" id %}
                </div>
            {% endblock %}

            {% block subtitle %}
                {% if id.subtitle %}
                    <h2>{{ id.subtitle }}</h2>
                {% endif %}
            {% endblock %}

            {% block page_summary %}
                {% if id.summary %}
                    <p class="summary article_summary" id="article-summary">{{ id.summary }}</p>
                {% endif %}
            {% endblock %}
            
			{% block page_depiction %}
                {% catinclude "_depiction.tpl" id %}
            {% endblock %}

			{% block page_body %}
				{% if id.body %}
					<div class="body article-body" id="article-body">{{ id.body|show_media }}</div>
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
			
            {% block copyrights %}
                {% optional include "_copyrights.tpl" %}
            {% endblock %}
		</article>

		<div class="col-md-4">
			{% catinclude "_aside.tpl" id %}
		</div>
	</div>
    #}
{% endblock %}
