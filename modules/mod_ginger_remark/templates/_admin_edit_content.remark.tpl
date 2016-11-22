{% extends "admin_edit_widget_std.tpl" %}

{# Show the edit fields to edit the name of a person #}

{% block widget_title %}
{_ Person details _}
{% endblock %}

{% block widget_title %}{{ ""|escapejs }}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}content-person{% endblock %}

{% block widget_content %}
    {% with m.rsc[id] as r %}
    {% with not id or m.rsc[id].is_editable as is_editable %}

    {% endwith %}
    {% endwith %}
{% endblock %}

{% block widget_content_nolang %}
    <fieldset>
    {% with m.rsc[id] as r %}
        <div class="row">
            <div class="form-group col-lg-4 col-md-4">
                <label class="control-label" for="anonymous_name">{_ Name _}</label>
                <div>
                    <input class="form-control" id="anonymous_name" type="text" name="anonymous_name" value="{{ r.anonymous_name }}" />
                </div>
            </div>
            <div class="form-group col-lg-4 col-md-4">
                <label class="control-label" for="anonymous_email">{_ E-mail _}</label>
                <div>
                    <input class="form-control" id="anonymous_email" type="text" name="anonymous_email" value="{{ r.anonymous_email }}" />
                </div>
            </div>
            <div class="form-group col-lg-4 col-md-4">
                <label class="control-label" for="anonymous_email_visible">{_ E-mail visible _}</label>
                <div>
                    <input class="form-control" id="anonymous_email_visible" type="checkbox" name="anonymous_email_visible" {% if r.anonymous_email_visible %}checked {% endif %} />
                </div>
            </div>
        </div>
    {% endwith %}
</fieldset>
{% endblock %}

