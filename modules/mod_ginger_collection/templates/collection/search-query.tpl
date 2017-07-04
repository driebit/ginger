{% with m.search[{beeldenzoeker filter=filter id_exclude=id_exclude query_id=query_id page=page|default:q.page index=index sort=sort text=text|default:q.qs prefix=prefix cat=cat related_to=related_to pagelen=pagelen}] as result %}
    {% include results_template items=result id=id show_pager=show_pager infinite_scroll=infinite_scroll hide_showmore_button noresults class=class|default:"list-search" list_template=list_template|default:"list/list-item-beeldenzoeker.tpl" %}
{% endwith %}
