{% extends "page.tpl" %}

{% block page_class %}t-collection t-grid{% endblock %}

{% block content %}
<div class="row">
    <div class="col-sm-12 col-md-12">
        <h2 class="page-title">{{ id.title }}</h2>

        {% include "_map.tpl" items=id.o.haspart container="map-canvas" height=250 %}

        {% include "_grid.tpl" items=id.o.haspart %}
    </div>
</div>

{% endblock %}
