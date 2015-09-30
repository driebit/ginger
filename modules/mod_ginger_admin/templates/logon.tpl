{% extends "base.tpl" %}

{# TODO: fix loading of CSS #}
{% lib "css/logon.css" %}

{% block title %}
{{ m.rsc.page_logon.title|default:[_"Sign in to", " ", m.config.site.title.value|default:"Zotonic"] }}
{% endblock %}

{% block body_class %}t-login{% endblock %}

{% block head_extra %}
    {% lib
        "css/z.modal.css"
        "css/z.icons.css"
        "css/logon.css"
    %}
{% endblock %}

{% block content %}
<div class="widget admin-logon">
    <div id="logon_box" class="widget-content">
        <div id="logon_error" class="alert alert-block alert-error">
            {% include "_logon_error.tpl" reason=error_reason %}
        </div>
        {% if zotonic_dispatch == `logon_reminder` %}
            {% include "_logon_password_reminder.tpl" %}
        {% elseif zotonic_dispatch == `logon_reset` %}
            {% include "_logon_password_reset.tpl" %}
        {% else %}
            {# <= 0.12 #}
            {% optional include "_logon_form.tpl" page=page|default:"/admin" hide_title %}

            {# >= 0.13 #}
            {% optional include "_logon_modal.tpl" style_boxed=1 style_width="600px" %}

        {% endif %}
    </div>
</div>

{#
<div class="logon_bottom">
    <ul id="logon_methods">
        {% all include "_logon_extra.tpl" %}
    </ul>
</div>
#}
{# Use a real post for all forms on this page, and not AJAX or Websockets. This will enforce all cookies to be set correctly. #}
{% javascript %}
z_only_post_forms = true;
{% endjavascript %}

{% endblock %}
