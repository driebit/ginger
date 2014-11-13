{% extends "admin_base.tpl" %}

{% block title %}{_ Admin log on _}{% endblock %}

{% block bodyclass %}noframe{% endblock %}

{% block navigation %} {% endblock %}

{% block content %}
<div class="widget admin-logon">
    <div id="logon_error">
        {% include "_logon_error.tpl" reason=error_reason %}
    </div>

    <div id="logon_form">
        {% if zotonic_dispatch == `logon_reminder` %}
            {% include "_logon_password_reminder.tpl" %}
        {% elseif zotonic_dispatch == `logon_reset` %}
            {% include "_logon_password_reset.tpl" %}
        {% else %}
            {% include "_logon_form.tpl" %}
        {% endif %}
    </div>    
</div>

{# Use a real post for all forms on this page, and not AJAX or Websockets. This will enforce all cookies to be set correctly. #}
{% javascript %}
z_only_post_forms = true;
{% endjavascript %}

{% endblock %}
