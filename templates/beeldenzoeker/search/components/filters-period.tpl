<div class="search__filters__section--period do_search_cmp_filters_period" data-property="dcterms:date">
    <h3 class="search__filters__title">{_ Period _}</h3>

    <div class="search__filters__section__inner">
	    <input type="number" name="filters_period_min" step="10" max="{{ now|date:"Y" }}" placeholder="{_ Start year _}">
	    <input type="number" name="filters_period_max" step="10" max="{{ now|date:"Y" }}" placeholder="{_ End year _}">
	</div>
</div>
