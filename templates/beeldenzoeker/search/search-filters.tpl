<div class="search__filters">
    <div class="search__filters__container">
        <button type="button" class="search__filters__mobile"><i class="icon--filter"></i>{_ Filters _}</button>
        <h3 class="search__filters__supertitle">{_ Refine search results _}</h3>
        <button class="search__filters__reset">{_ Reset filters _} <i class="icon--close"></i></button>
        {% block search_sidebar %}
        	{% include "beeldenzoeker/components/search/filters-period.tpl" %}
            {% include "beeldenzoeker/components/search/filters-license.tpl" %}
            {% include "beeldenzoeker/components/search/filters-subjects.tpl" %}
        {% endblock %}
    </div>
</div>
