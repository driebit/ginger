{% extends "admin_edit_widget_std.tpl" %}

{# Show the edit fields to edit the name of a person #}

{% block widget_title %}{_ Links _}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}content-links{% endblock %}
{% block widget_class %} edit-links {% endblock %}

{% block widget_content %}
{% with m.rsc[id] as r %}
    <div class="row">
        <div class="col-lg-6 col-md-6">
            <div class="form-group address_twitter">
                <label class="control-label" for="twitter">{_ Twitter _}</label>
                <input class="form-control" id="twitter" type="text" name="twitter" value="{{ r.twitter }}">
            </div>
            <div class="form-group address_linkedin">
                <label class="control-label" for="linkedin">{_ LinkedIn _}</label>
                <input class="form-control" id="linkedin" type="text" name="linkedin" value="{{ r.linkedin }}">
            </div>
            <div class="form-group address_facebook">
                <label class="control-label" for="facebook">{_ Facebook _}</label>
                <input class="form-control" id="facebook" type="text" name="facebook" value="{{ r.facebook }}">
            </div>
        </div>

        <div class="col-lg-6 col-md-6">
            <div class="form-group address_website">
                <label class="control-label" for="website">{_ Website _}</label>
                <input class="form-control" id="website" name="website" value="{{ r.website }}">
            </div>
            <div class="form-group checkbox">
                <label>
                    <input type="checkbox" id="field-is-website=redirect" name="is_website_redirect" value="1"
                        {% if r.is_website_redirect %}checked{% endif %}
                        {% if not is_editable %}disabled="disabled"{% endif %}
                    />
                    {_ Redirect to website on page view _}
                </label>
            </div>

        </div>
    </div>
{% endwith %}
{% endblock %}
