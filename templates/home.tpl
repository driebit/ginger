{% extends "base.tpl" %}

{% block content %}
  <div class="row-fluid">
    <div class="span8">
        <div class="hero-unit">

        {% with m.rsc.home as home %}
            <h2 class="page-title">{{ home.title }}</h2>

            {% include "_slider.tpl" ids=m.rsc.home_set.haspart slider="carousel" pager="carousel-pager" mediaclassSlider="default" mediaclassPager="thumbnail" %}
            
            {% if home.summary %}
                <p class="summary">
                    {{ home.summary }}
                </p>
            {% endif %}

            {% if home.body %}
                <div class="body">
                    {{ home.body }}
                </div>
            {% endif %}

            {% block thumbnails %}{% endblock %}

            <aside class="home-aside">
                {% include "_list.tpl" title="news" class="news" items=m.search[{latest cat="news" pagelen=10}] %}
            </aside>
        {% endwith %}
        </div>
    </div>
  </div>
{% endblock %}
