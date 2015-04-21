{% extends "base.tpl" %}

{# TODO: fix loading of CSS #}
{% lib "css/logon.css" %}

{% block title %}
{{ m.rsc.page_logon.title|default:[_"Sign in to", " ", m.config.site.title.value|default:"Zotonic"] }}
{% endblock %}

{% block content %}
        <div id="logon_box" class="widget-content">
            {# <= 0.12 #}
            {% optional include "_logon_form.tpl" page=page|default:"/admin" hide_title %}

            {# >= 0.13 #}
            {% optional include "_logon_modal.tpl" style_boxed=1 style_width="600px" %}
        </div>
{% endblock %}