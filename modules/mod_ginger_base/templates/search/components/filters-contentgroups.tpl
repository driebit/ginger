{% with
    m.rsc.search_contentgroups.o.haspart,
    title|default:_"Content"
as
    results,
    title
%}
    <div class="search__filters__section">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul class="do_search_cmp_filters_contentgroups">

        {% for id in results %}
            <li><input name="content_group" id="{{ id.title|slugify }}" type="radio" value="{{ id.id }}"><label for="{{ id.title|slugify }}">&nbsp;{{ id.title }}</label></li>
        {% endfor %}

        </ul>
    </div>
{% endwith %}
