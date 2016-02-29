<div id="{{ list_id }}-buttons" class="search__pager">
    <div class="search__pager__result-counter">{{items.total}} resultaten</div>
    <div class="do_search_cmp_pager search__pager__pagination">
        {% pager result=items dispatch="search" qargs %}
    </div>
</div>
