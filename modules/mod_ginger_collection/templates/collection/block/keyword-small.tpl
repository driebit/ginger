{% extends "collection/list/list-item.tpl" %}

{% block link %}{{ url }}{% endblock %}

{% block item_image %}
    {% include "list/list-item-image.tpl" url=dbpedia_rdf.thumbnail|default:wikidata_rdf.thumbnail|https %}
{% endblock %}

{% block item_title %}
    <h3 class="list__item__content__title">{{ dbpedia_rdf.title|truncate:60 }}</h3>
{% endblock %}

{% block item_summary %}
    {{ dbpedia_rdf.abstract|default:wikidata_rdf.abstract|truncate:150 }}
{% endblock %}

{% block read_more %}
    {% include "collection/readmore.tpl" source="Wikipedia" class="list-item_readmore"%}
{% endblock %}
