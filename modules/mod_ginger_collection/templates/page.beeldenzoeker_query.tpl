{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-query{% endblock %}

{% block content %}

    {% include "masthead/masthead.tpl" %}

    <main>
        <div class="adlib-object__actions">
            <div class="main-container">
                {% include "beeldenzoeker/share.tpl" %}
            </div>
        </div>
        <article class="main-content">
            {% include "page-title/page-title.tpl" %}

            {% include "subtitle/subtitle.tpl" %}

            {% include "summary/summary.tpl" %}

            {% include "body/body.tpl" %}

        </article>

        {% block search_query %}
            {% include "beeldenzoeker/search-query-wrapper.tpl" id_exclude=id query_id=id show_pager=`false` %}
        {% endblock %}
    </main>

{% endblock %}

