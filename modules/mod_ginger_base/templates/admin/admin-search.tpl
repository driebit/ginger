{% extends "admin_edit_widget_std.tpl" %}
{% block widget_title %}{_ Search _}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}sidebar-rights{% endblock %}

{% block widget_content %}
<fieldset>
    <div class="row">
        <div class="col-md-12">
            <div class="checkbox">
                <label>
                    <input name="is_excluded_from_search" id="{{ #is_excluded_from_search}}" type="checkbox" {% if id.is_excluded_from_search %}checked{% endif %} /> {_ Exclude from search results _}
                </label>
            </div>
        </div>
    </div>
</fieldset>
{% endblock %}
