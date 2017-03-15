{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-object{% endblock %}

{% block content %}

{% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
	{% with m.search[{elastic index=index filter=['_type', q.database] filter=['_id', q.object_id] pagelen=1}]|first as result %}
        {% with result._source as record %}

            {% include "beeldenzoeker/depiction.tpl" record=record width=1600 height=1600 template="beeldenzoeker/masthead.tpl" %}

            <main role="main">
                <div class="adlib-object__actions">
                    <div class="main-container">
                        {% include "beeldenzoeker/share.tpl" record=record %}
                        {% include "beeldenzoeker/download.tpl" record=record %}
                    </div>
                </div>
                <article class="main-content">
                    {% block title %}
                        <h1 class="page-title">{% include "beeldenzoeker/title.tpl" title=record['dcterms:title']|default:record.title %}</h1>
                    {% endblock %}

                    {% if record.title[2] %}
                        <h2>{{ record.title[2] }}</h2>
                    {% endif %}

                    {% block item_summary %}{% endblock %}

                    {% block item_body %}
                        {% if record['dcterms:description'] as body %}
                            <p>{{ body }}</p>
                        {% endif %}
                    {% endblock %}

                </article>

                {% include "beeldenzoeker/record-meta.tpl" record=record %}

                {% print record %}

                {# Part of collections #}
            </main>

        {% endwith %}
    {% endwith %}
{% endwith %}

{% endblock %}
