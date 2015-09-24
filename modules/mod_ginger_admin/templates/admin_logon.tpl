{% extends "admin_base.tpl" %}

{% block title %}
{_ Admin log on _}
{% endblock %}

{% block bodyclass %}noframe t-login{% endblock %}

{% block navigation %}
<div class="navbar navbar-branded navbar-fixed-top">
    <div class="navbar-header">
        <a class="navbar-brand" href="http://{{ m.site.hostname }}" title="{_ visit site _}"><span class="zotonic-logo"><em>Zotonic</em></span></a>
    </div>
</div>
{% endblock %}

{% block content %}
    <div class="widget admin-logon">

        <div class="widget-header"><img alt="Driebit Ginger" class="logon-logo" src="/lib/images/ginger-logo.png"></div>
        <div class="widget-content">
            {% include
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
