{% with
    title|default:_"Collections"
as
    title
%}
    <div class="search__filters__section">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul class="do_search_cmp_filters_categories">
        	<li><input name="collection" id="collection" type="checkbox" value="collection"><label for="collection">{_ Collections _}</label></li>
        </ul>
    </div>
{% endwith %}
