<div class="search__filters__section--period {#do_search_cmp_filters_period #}">
    <h3 class="search__filters__title">{_ Period _}</h3>

    <div class="search__filters__section__inner">
	    <input type="number" name="filters_period_start" step="10" max="{{ now|date:"Y" }}" placeholder="{_ Start year _}">
	    <input type="number" name="filters_period_end" step="10" max="{{ now|date:"Y" }}" placeholder="{_ End year _}">

	    {# <select name="filters_period_century">
	    	<option value="">{_ Century _}</option>
	        <option value="century_1">1e eeuw</option>
	        <option value="century_2">2e eeuw</option>
	        <option value="century_3">3e eeuw</option>
	        <option value="century_4">4e eeuw</option>
	        <option value="century_5">5e eeuw</option>
	    </select> #}
	</div>
</div>
