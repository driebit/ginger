{% extends "base.tpl" %}

{% block page_class %}t-page{% endblock %}

{% block content %}
<div class="row">
    <div class="col-sm-8 col-md-8">

            <h2 class="page-title">{{ id.title }}</h2>

            {% block page_image %}
                {% if id.depiction %}
                    {% image id.depiction mediaclass="default" crop=id.depiction.id.crop_center alt="" %}
                {% elif id.media %}
                    {% media id.media.id width=600 %}
                {% endif %}
            {% endblock %}

            {% if id.summary %}
                <p class="summary">
                    </p><h3>{{ id.summary }}</h3>
                <p></p>
            {% endif %}

            {% if id.body %}
                <div class="body">
                    {{ id.body|show_media }}
                </div>
            {% endif %}

            {% block below_body %}{% endblock %}
            {% block thumbnails %}
                {% catinclude "_page_thumbnails.tpl" id %}
            {% endblock %}

    </div>


    <div class="col-lg-4 col-md-4">
        {% catinclude "_aside.tpl" id %}
    </div>

</div>

<div class="footer row">
    {% block footer %}{% endblock %}
</div>


{% endblock %}