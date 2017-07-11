{% extends "list/list-item-beeldenzoeker.tpl" %}

{% block link %}{{ rdf['http://xmlns.com/foaf/0.1/isPrimaryTopicOf'] }} {% endblock %}

{% block item_image %}
    {% include "list/list-item-image.tpl" url=rdf.thumbnail %}
{% endblock %}

{% block item_title %}
    <h3 class="list__item__content__title">{{ rdf.title|truncate:60 }}</h3>
{% endblock %}

{% block item_summary %}
    {{ rdf.abstract|truncate:150 }}
{% endblock %}

{% block read_more %}
    {% include "collection/readmore.tpl" url=rdf['http://xmlns.com/foaf/0.1/isPrimaryTopicOf'] source="Wikipedia" class="list-item_readmore"%}
{% endblock %}
