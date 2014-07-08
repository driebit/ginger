<form class="search-form" method="GET" action="{% url search %}">
    <input type="text" class="search-query" value="{{ q.qs|escape }}" name="qs" placeholder="Search" autocomplete="off" />

    {% wire name="show_search_results"
        action={update target="search-results" template="_search_results.tpl"}
    %}
</form>

<div id="search-results"></div>
