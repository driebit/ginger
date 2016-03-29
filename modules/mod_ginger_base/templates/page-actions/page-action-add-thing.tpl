{% with btn_class|default:"page-action--add" as btn_class %}
    {% include "_action_ginger_connection.tpl" category=category cg_id=id.content_group_id predicate=predicate add_author direction='out' btn_class=btn_class btn_title=btn_title tab="new" tabs_enabled=["new"] %}
{% endwith %}
