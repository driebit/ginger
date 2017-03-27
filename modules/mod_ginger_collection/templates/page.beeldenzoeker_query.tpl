{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-query{% endblock %}

{% block content %}

    {% include "masthead/masthead.tpl" %}

    <main role="main">
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

            {% with m.search[{beeldenzoeker query_id=id index=m.config.mod_ginger_adlib_elasticsearch.index.value}] as result %}
                {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button dispatch_pager="beeldenzoeker" list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}

        {% endblock %}
    </main>

{% endblock %}

