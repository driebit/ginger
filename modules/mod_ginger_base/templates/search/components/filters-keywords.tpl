{% with
    m.rsc.search_filters.o.haspart,
    title|default:_"Filters"
as
    results,
    title
%}
    <div class="search__filters__section">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul class="do_search_cmp_filters_keywords">

        {% for id in results %}
            <li><input name="{{ id.title }}" id="{{ id.title|slugify }}" type="checkbox" value="{{ id.id }}"><label for="{{ id.title|slugify }}">{{ id.title }}</label></li>
        {% endfor %}

        </ul>
    </div>
{% endwith %}
