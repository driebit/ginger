<div class="navbar navbar-default">
    <div class="container-fluid">
        {% menu menu_id=menu_id id=id %}

        <ul class="nav navbar-nav">
            {% include "_language_switch.tpl" is_nav %}
        </ul>
        {% include "_search_form.tpl" %}
        {% include "_nav_edit.tpl" %}
        {% include "_nav_logon.tpl" %}
    </div>
</div>