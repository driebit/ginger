{% extends "admin_base.tpl" %}

{% block title %}
{_ Admin log on _}
{% endblock %}

{% block bodyclass %}noframe{% endblock %}

{% block navigation %} {% endblock %}

{% block content %}
    <div class="widget admin-logon">
        <img alt="Driebit Ginger" class="logon-logo" src="/lib/images/ginger-logo.png">
        <div id="logon_box" class="widget-content">
            <div id="logon_error" class="alert alert-block alert-error"></div>
            {# <= 0.12 #}
            {% optional include "_logon_form.tpl" page=page|default:"/admin" hide_title %}

            {# >= 0.13 #}
            {% optional include
                "_logon_modal.tpl"
                page=page|default:"/admin"
                logon_context="admin_logon"
            %}
        </div>
    </div>
{% endblock %}

{% block logonfooter %} 
<footer class="logon-footer">
    <div class="logon-footer_inner">
        <a href="http://www.ginger.nl" target="_blank"><img src="/lib/images/ginger-nl.png" alt="Ginger website"></a>
        <a href="http://www.driebit.nl" target="_blank"><img src="/lib/images/driebit-nl.png" alt="Driebit website"></a>
    </div>
</footer>
{% endblock %}
