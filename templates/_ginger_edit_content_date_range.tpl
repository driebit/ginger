{% extends "admin_edit_widget_i18n.tpl" %}

{# Widget for editing abstract event date_start/date_end #}

{% block widget_title %}{_ Date range _}{% endblock %}
{% block widget_id %}sidebar-date-range{% endblock %}
{% block widget_class %} edit-date-range {% endblock %}

{% block widget_content_nolang_before %}
    <div class="date-range row">
        <div class="form-group col-xs-12">
            <label class="control-label">Date range</label>
        </div>
        <div class="checkbox col-md-12">
            {% with id.date_is_all_day or (not id.date_start and not id.date_end) as date_is_all_day %}
                <label>
                    <input name="date_is_all_day" id="{{ #all_day }}" type="checkbox"  {% if date_is_all_day %}checked{% endif %}>
                    All day event?
                </label>

                {% if date_is_all_day %}
                    {% javascript %}
                        $('.do_timepicker').hide();
                    {% endjavascript %}
                {% endif %}
            {% endwith %}
        </div>
        {% javascript %}
            $("#{{ #all_day }}").on('change', function() {
                var $times = $(this).closest('.date-range').find('.do_timepicker');
                if ($(this).is(":checked"))
                    $times.fadeOut("fast").val('');
                else
                    $times.fadeIn("fast");
            });
        {% endjavascript %}
        <div class="form-group date-range_start col-xs-12 col-md-5">
            <label class="control-label">{_ From _}</label>
            {% include "_edit_date.tpl" date=id.date_start time_id="date_start_time" name="date_start" is_end=0 date_is_all_day=id.date_is_all_day %}
        </div>
        <div class="form-group date-range_stop col-xs-12 col-md-5">
            <label class="control-label">{_ Till _}</label>
            {% include "_edit_date.tpl" date=id.date_end time_id="date_end_time" name="date_end" is_end=1 date_is_all_day=id.date_is_all_day %}
        </div>
    </div>
{% endblock %}

{% block widget_content %}
    <div class="row">
        <div class="form-group col-xs-12">
            <label class="control-label" for="{{ #remarks }}{{ lang_code_for_id }}">{_ Remarks _}</label>
            <input type="text" id="{{ #remarks }}{{ lang_code_for_id }}" name="date_remarks{{ lang_code_with_dollar }}" 
                value="{{ is_i18n|if : id.translation[lang_code].date_remarks : id.date_remarks }}"
                {% if not is_editable %}disabled="disabled"{% endif %}
                {% include "_language_attrs.tpl" language=lang_code class="do_autofocus field-title form-control" %}
                placeholder="{_ Remarks _} {{ lang_code_with_brackets }}">
        </div>
    </div>
{% endblock %}