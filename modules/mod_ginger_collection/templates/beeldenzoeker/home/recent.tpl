<div class="beeldenzoeker-home__latest">
    <div class="main-container">
        <h2 class="beeldenzoeker-home__section-title">Recent gewijzigd</h2>

        {% with
            sort|default:"-modified",
            filter|default:[['reproduction.value', `exists`], ['_type', 'resource']]
        as
            sort,
            filter
        %}
            {% include "beeldenzoeker/search-query-wrapper.tpl" cat="beeldenzoeker_query" results_template="list/list-beeldenzoeker-infinite-scroll.tpl" sort=sort filter=filter pagelen=15 show_pager=`false` class="list" %}
        {% endwith %}
    </div>
</div>
