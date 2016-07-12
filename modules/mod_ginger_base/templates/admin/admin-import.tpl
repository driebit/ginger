{% extends "admin_base.tpl" %}

{% block title %}{_ Import from CSV _}{% endblock %}

{% block content %}

    <div class="admin-header">
        <h2>{_ Import from CSV _}</h2>
    </div>

    <div class="well">
        {# This duplicates mod_import_csv/templates/_admin_status.tpl #}
        {% if m.acl.use.mod_import_csv %}
        <div class="form-group">
            <div>
                {% button class="btn btn-default" text=_"Import CSV file..." action={dialog_open title=_"Import CSV file" template="_dialog_import_csv.tpl"} %}
                <span class="help-block">{_ Import data from a CSV file. _}</span>
            </div>
        </div>
        {% endif %}
    </div>

{% endblock %}
