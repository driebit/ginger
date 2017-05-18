{#
    dynamic: whether the list items should be based on current search results
    sort_by_count: sort the list by doc count instead of alphabetically (default)
#}
{% with
    buckets|default:q.buckets,
    q.values,
    title|default:_"Term",
    property,
    load_more|default:false,
    load_more_items_visible|default:5,
    load_more_length|default:10,
    dynamic|default:false,
    sort_by_count|default:false,
    options_template|default:"search/components/filter-terms-options.tpl"
as
    buckets,
    values,
    title,
    property,
    load_more,
    load_more_items_visible,
    load_more_length,
    dynamic,
    sort_by_count,
    options_template
%}
    <div class="search__filters__section is-open do_search_cmp_filter_terms  {{ load_more|if:"search__filters__section--load_more":"" }} " data-load-more-length="{{ load_more_length }}" data-property="{{ property }}" data-dynamic="{{ dynamic }}" data-sort-by-count="{{ sort_by_count }}" data-update-event="{{ #search_filter_update}}">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul id="{{ #search_filter }}"></ul>
        {% if load_more %} <span class="filter-down-btn"><span class="glyphicon glyphicon-plus">&nbsp;</span>{_ Load more _}</span> {% endif %}
    </div>

    {% wire name=#search_filter_update action={update target=#search_filter template=options_template dynamic=dynamic load_more=load_more load_more_items_visible=load_more_items_visible} %}

{% endwith %}
