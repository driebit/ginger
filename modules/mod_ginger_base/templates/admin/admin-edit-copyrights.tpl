{% extends "admin_edit_widget_std.tpl" %}
{% block widget_title %}{_ Copyrights _}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}sidebar-rights{% endblock %}

{% block widget_content %}
    {% catinclude "copyrights/edit-copyrights.tpl" id rights=id.rights %}
{% endblock %}
