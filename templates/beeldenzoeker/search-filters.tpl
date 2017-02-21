<div class="search__filters">
    <div class="search__filters__container">
        <button type="button" class="search__filters__mobile"><i class="icon--filter"></i>{_ Filters _}</button>
        <h3 class="search__filters__supertitle">{_ Refine search results _}</h3>
        <button class="search__filters__reset">{_ Reset filters _} <i class="icon--close"></i></button>
        {% block search_sidebar %}
        	{# {% include "beeldenzoeker/components/filters-collections.tpl" %} #}
        	{% include "beeldenzoeker/components/filters-period.tpl" %}
            {% include "beeldenzoeker/components/filters-license.tpl" %}
        	{# {% include "beeldenzoeker/components/filters-creator.tpl" %}
        	{% include "beeldenzoeker/components/filters-resolution.tpl" %}
        	{% include "beeldenzoeker/components/filters-orientation.tpl" %}
        	{% include "beeldenzoeker/components/filters-material.tpl" %}
        	{% include "beeldenzoeker/components/filters-technique.tpl" %} #}
        	{# {% include "search/components/filters-keywords.tpl" %} #}
        {% endblock %}
    </div>
</div>
