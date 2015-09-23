{% extends "admin_base.tpl" %}

{% block title %}{_ Export to CSV _}{% endblock %}

{% block content %}

    <div class="admin-header">
        <h2>{_ Export to CSV _}</h2>

        <div class="well">
            <div class="form-group">
                <div>
                    <a class="btn btn-default" href="{% url admin_ginger_export_csv %}">{_ Export resources _}</a>
                    <span class="help-block">Export resources to CSV</span>
                </div>

                {% all include '_admin_export.tpl' %}
            </div>

        </div>
    </div>

{% endblock %}
