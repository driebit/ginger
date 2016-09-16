<div class="search__filters__section--date search__filters__section do_search_cmp_filters_datepicker">
    <h3 class="search__filters__title">Wanneer wil je op pad?</h3>
    <div
        type="text"
        name="dt:ymd:{{ is_end }}:{{ name }}"
        value="{{ date|date:'Y-m-d':date_is_all_day }}"
        class="do_datepicker {{ class }} {{ date_class }}"
        >
    </div>
</div>
