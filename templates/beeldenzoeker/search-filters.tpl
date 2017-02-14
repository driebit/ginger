<div class="search__filters">
    <div class="search__filters__container">
        <button type="button" class="search__filters__mobile"><i class="icon--filter"></i>{_ Filters _}</button>
        {% block search_sidebar %}
        	{% include "search/components/filters-keywords.tpl" %}
        {% endblock %}
    </div>
</div>
