{% include "list/list-beeldenzoeker.tpl" %}

<div id="more-results">
    {% wire name="moreresults" action={replace target="more-results" template="beeldenzoeker/_home-more-results.tpl" page=items.page+1 sort=sort filter=filter class=class} %}
</div>
