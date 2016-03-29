{% with btn_class|default:"page-action--add" as btn_class %}
    {% include "_action_ginger_connection.tpl" category='article' cg_id=id.content_group_id predicate='haspart' btn_class=btn_class dispatch=zotonic_dispatch tabs_enabled=["new"] objects=[[m.acl.user, `author`]] %}
{% endwith %}
