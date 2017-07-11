<div class="search__filters__section--license is-open do_search_cmp_filters_license">
    <h3 class="search__filters__title">{_ CC license _}</h3>

    <ul id="filters_license_options"></ul>
</div>

{% wire name="update_filter_license" action={update target="filters_license_options" template="collection/search/components/filters-license-options.tpl"} %}
