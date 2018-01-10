{% extends "admin_edit_widget_std.tpl" %}

{% block widget_title %}{_ Dates _}{% endblock %}

{% block widget_content %}
    <fieldset class="form-horizontal">
        <div class="row">
            <label class="control-label col-md-3">{_ Birth date _}</label>
            <div class="col-md-2">
                <label class="control-label" for="{{ #date_start_qualifier }}">{_ Qualifier _}</label>
                <input class="form-control" type="text" id="{{ #date_start_qualifier }}" name="date_start_qualifier" value="{{ r.date_start_qualifier }}" {% if not is_editable or id == 1 %}disabled="disabled"{% endif %}/>
            </div>
            {% include "date/edit-date-granular.tpl" name="date_start" %}
        </div>

        <div class="row">
            <label class="control-label col-md-3">{_ Death date _}</label>
            <div class="col-md-2">
                <label class="control-label" for="{{ #date_end_qualifier }}">{_ Qualifier _}</label>
                <input class="form-control" type="text" id="{{ #date_end_qualifier}}" name="date_end_qualifier" value="{{ r.date_end_qualifier }}" {% if not is_editable or id == 1 %}disabled="disabled"{% endif %}/>
            </div>
            {% include "date/edit-date-granular.tpl" name="date_end" %}
        </div>
    </fieldset>
{% endblock %}
