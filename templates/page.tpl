{% extends "base.tpl" %}

{% block page_class %}page{% endblock %}

{% block content %}
    <div class="row">
        {% block main %}
            <article class="col-md-8">
                {% block title %}
                    <h2 class="page_title">{{ id.title }}</h2>
                {% endblock %}

                {% block image %}
                    {% if id.depiction %}
                        {% image id.depiction mediaclass="default" class="img-responsive" alt="" %}
                    {% endif %}
                {% endblock %}

                {% block summary %}
                    {% if id.summary %}
                        <p class="page_summary">{{ id.summary }}</p>
                    {% endif %}
                {% endblock %}

                {% block body %}
                    {% if id.body %}
                        <div class="page_body">{{ id.body|show_media }}</div>
                    {% endif %}
                {% endblock %}

                {% block images %}
                    {% include "_images.tpl" %}
                {% endblock %}
            </article>
        {% endblock %}
    
        {% block aside %}
            <div class="col-md-4">
                {% include "_aside.tpl" %}
            </div>
        {% endblock %}
    </div>
{% endblock %}