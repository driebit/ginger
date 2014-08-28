{% extends "base.tpl" %}

{% block page_class %}t-page{% endblock %}

{% block content %}
<div class="row-fluid">
    <div class="span8">
        <div class="hero-unit">

            <h2 class="page-title">{{ id.title }}</h2>

            {% if id.o.depiction|length > 1 %}
                {% include "_slider.tpl" ids=id.o.depiction slider="carousel" pager="carousel-pager" mediaclassSlider="default" mediaclassPager="thumbnail" %}
            {% else %}
                {% if id.depiction %}
                    {% image id.depiction mediaclass="default" crop=id.depiction.id.crop_center alt="" %}
                {% elif id.media %}
                    {% media id.media.id width=600 %}
                {% endif %}
            {% endif %}

            {% if id.summary %}
                <p class="summary">
                    <h3>{{ id.summary }}</h3>
                </p>
            {% endif %}

            {% if id.body %}
                <div class="body">
                    {{ id.body|show_media }}
                </div>
            {% endif %}

            {% block below_body %}{% endblock %}
            {% block thumbnails %}{% endblock %}

        </div>

    </div>

    <div class="row-fluid">
        <div class="span4">
            {% catinclude "_aside.tpl" id %}
        </div>
    </div>

    <div class="row-fluid footer">
    </div>

</div>

{% endblock %}
