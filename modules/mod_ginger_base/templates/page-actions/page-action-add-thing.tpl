{% with
    btn_class|default:"page-action--add",
    tabs_enabled|default:["new"],
    tab|default:"new"    
 as
    btn_class,
    tabs_enabled,
    tab
%}

    {% include "_action_ginger_connection.tpl" id=id
                                               category=category
                                               cg_id=cg_id|default:id.content_group_id
                                               predicate=predicate
                                               add_author
                                               direction='out'
                                               btn_class=btn_class
                                               btn_title=btn_title
                                               tab=tab
                                               tabs_enabled=tabs_enabled
                                               hide_help_text=hide_help_text
                                               %}

{% endwith %}
