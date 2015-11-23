{% extends "admin_edit_widget_std.tpl" %}

{% block widget_title %}

{_ ginger_export.admin.title _}

<div class="widget-header-tools">
    <a href="javascript:void(0)" class="z-btn-help do_dialog" data-dialog="title: '{_ Export _}', text: '{_ ginger_export.admin.help _}'"></a>
</div>

{% endblock %}

{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}sidebar-export{% endblock %}

{% block widget_content %}

<div class="form-group">
    <div>
        <a class="btn btn-default" href="{% url export_rsc_csv id=id %}">{_ Export _} {{ m.rsc[id.category_id].title|lower }} {_ to _} CSV</a>
    </div>
</div>

{% endblock %}
