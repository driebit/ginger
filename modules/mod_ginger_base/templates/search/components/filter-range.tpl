{% with
    property,
    title,
    min,
    max,
    min_placeholder|default:_"Start",
    max_placeholder|default:_"End",
    dynamic
as
    property,
    title,
    min,
    max,
    min_placeholder,
    max_placeholder,
    dynamic
%}

    <div class="search__filters__section--period do_search_cmp_filter_range is-open" data-property="{{ property }}">
        <h3 class="search__filters__title">{{ title }}</h3>

        <div class="search__filters__slider"></div>
        <div class="search__filters__section__inner">
            <input type="number" name="{{ #search_filter_min }}" placeholder="{{ min_placeholder }}">
            <input type="number" name="{{ #search_filter_max }}" placeholder="{{ max_placeholder }}">
        </div>
    </div>

{% endwith %}
