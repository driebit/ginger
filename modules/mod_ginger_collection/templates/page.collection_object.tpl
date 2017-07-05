{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--adlib-object{% endblock %}

{% block title %}
    {% with m.collection_object[q.database][q.object_id]._source as record %}
        {{ record['dcterms:title'] }}
    {% endwith %}
{% endblock %}

{% block content %}

{% with m.collection_object[q.database][q.object_id]._source as record %}

    {% include "beeldenzoeker/depiction.tpl" record=record width=1600 height=1600 template="beeldenzoeker/masthead.tpl" %}

    <main>
        <div class="adlib-object__actions">
            <div class="main-container">
                {% include "beeldenzoeker/share.tpl" record=record %}
                {% include "beeldenzoeker/depiction.tpl" record=record template="beeldenzoeker/download.tpl" %}
            </div>
        </div>
        <article class="adlib-object__description">
            <header>
                <h6>{_ Dating _} {% include "collection/metadata/date.tpl" %}</h6>
                {% if record['dcterms:creator']|first as creator %}
                    <h6>
                        {_ Creator _}
                        <a href="{% url collection_search qs=creator['rdfs:label'] %}">{{ creator['rdfs:label'] }}</a>
                    </h6>
                {% endif %}
            </header>

            {% block page_title %}
                <h1 class="page-title">{% include "beeldenzoeker/title.tpl" title=record['dcterms:title']|default:record.title %}</h1>
            {% endblock %}

            {% if record.title[2] %}
                <h2>{{ record.title[2] }}</h2>
            {% endif %}

            {% block item_summary %}
                {% if record['dcterms:abstract'] as abstract %}
                    <p class="summary">
                        {{ abstract }}
                    </p>
                {% endif %}
            {% endblock %}

            {% block item_body %}
                {% if record['dcterms:description'] as body %}
                    {% if body|length > 400 %}
                        <div id="adlib-desc" class="adlib-description">
                            <div class="adlib-description-readmore">
                                <h6 class="adlib-description__expand do_expand" data-parent="adlib-desc" data-content="adlib-desc-inner">{_ Detailed description _}</h6>
                            </div>
                            <div id="adlib-desc-inner" class="adlib-description__inner">
                                <p>{{ body }}</p>
                            </div>
                        </div>
                    {% else %}
                        <p>{{ body }}</p>
                    {% endif %}
                {% endif %}
            {% endblock %}
        </article>

        <aside class="adlib-object__aside">
            {% block institute %}
            <div class="adlib-object__aside-item">
                {% if record['dbpedia-owl:museum'] as museum %}
                    <h6>{_ Institute _}</h6>
                    <p>
                        {% if museum['@id'] %}
                            {% include "beeldenzoeker/metadata/meta-link.tpl" href=museum['@id'] content=museum['rdfs:label'] %}
                        {% else %}
                            {{ museum['rdfs:label'] }}
                        {% endif %}
                    </p>
                {% endif %}
            </div>
            {% endblock %}

            <h6 class="adlib-meta__expand do_expand" data-parent="adlib-meta" data-content="adlib-meta-inner">Meer informatie</h6>
        </aside>

        <div id="adlib-meta" class="adlib-meta">
            <div id="adlib-meta-inner" class="adlib-meta__inner">
                {% include "beeldenzoeker/record-meta.tpl" record=record %}
            </div>
        </div>

        {% block creator %}
            {% include "collection/creator.tpl" object=record %}
        {% endblock %}

        {% block related %}{% endblock %}

        {% block keywords %}
            {% include "collection/keywords.tpl" uris=(record['rdf:type'] ++ record['dcterms:subject'])|uri %}
        {% endblock %}

        {% if q.debug %}
            {% print record %}
        {% endif %}
    </main>

{% endwith %}

{% endblock %}
