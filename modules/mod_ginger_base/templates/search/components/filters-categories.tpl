{% with
    m.rsc.search_categories.o.haspart,
    title|default:_"Categories"
as
    results,
    title
%}

{% if results %}
    <div class="search__filters__section">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul class="do_search_cmp_filters_categories">

        {% for id in results %}
            <li><input name="{{ id.title }}" id="{{ id.title|slugify }}" type="checkbox" value="{{ id.name }}"><label for="{{ id.title|slugify }}">{{ id.title }}</label></li>
        {% endfor %}

        </ul>
    </div>
{% endif %}
{% endwith %}
