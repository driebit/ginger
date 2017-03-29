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
            {% include "beeldenzoeker/search-query-wrapper.tpl" cat="beeldenzoeker_query" sort=sort filter=filter pagelen=15 infinite_scroll class="list" %}
        {% endwith %}
    </div>
</div>
