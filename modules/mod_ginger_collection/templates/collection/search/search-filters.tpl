<div class="search__filters">
    <div class="search__filters__container">
        <button type="button" class="search__filters__mobile"><i class="icon--filter"></i>{_ Filters _}</button>
        <h3 class="search__filters__supertitle">{_ Refine search results _}</h3>
        <a href="{% url collection_search %}" class="search__filters__reset">{_ Reset filters _} <i class="icon--close"></i></a>
        {% block search_sidebar %}
            {% include "search/components/filter-range.tpl" title=_"Period" property="dcterms:date" %}
            {% include "collection/search/components/filters-license.tpl" %}
            {% include "collection/search/components/filters-subjects.tpl" %}
        {% endblock %}
    </div>
</div>
