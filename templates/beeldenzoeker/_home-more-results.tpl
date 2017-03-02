{% with m.search[{beeldenzoeker page=page index=m.config.mod_ginger_adlib_elasticsearch.index.value ++ "," ++ m.config.mod_elasticsearch.index.value sort=sort text=text|default:q.qs cat="beeldenzoeker_query" pagelen=15 }] as result %}

    {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_template="list/list-item-beeldenzoeker.tpl" %}

    <div id="more-results">
    	{% wire name="moreresults" action={replace target="more-results" template="beeldenzoeker/_home-more-results.tpl" page=page+1 } %}
    </div>
{% endwith %}