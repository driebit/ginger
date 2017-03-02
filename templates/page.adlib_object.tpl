{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-object{% endblock %}

{% block content %}

{% with index|default:m.config.mod_ginger_adlib_elasticsearch.index.value as index %}
	{% with m.search[{elastic index=index filter=['priref', q.object_id] pagelen=1}]|first as result %}
        {% with result._source as record %}

            {% include "beeldenzoeker/masthead.tpl" record=record %}

            <main role="main">
                <div class="adlib-object__actions">
                    <div class="main-container">
                        {% include "beeldenzoeker/share.tpl" record=record %}
                        {% include "beeldenzoeker/download.tpl" record=record %}
                    </div>
                </div>
                <article class="main-content">
                    <h1 class="page-title">{% include "beeldenzoeker/title.tpl" title=record.title %}</h1>

                    {% if record.title[2] %}
                        <h2>{{ record.title[2] }}</h2>
                    {% endif %}

                    {% block item_summary %}
                        {% if record.AHMteksten['AHM.texts.tekst'] %}
                            <p class="summary">
                                {{ record.AHMteksten['AHM.texts.tekst']|truncate:"100" }}
                            </p>
                        {% endif %}
                    {% endblock %}

                    {% block item_body %}
                        {% if record.AHMteksten['AHM.texts.tekst'] %}
                            <p>
                                {{ record.AHMteksten['AHM.texts.tekst']}}
                            </p>
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
