{% extends "admin_base.tpl" %}

{% block title %}
{_ Admin log on _}
{% endblock %}

{% block bodyclass %}noframe t-logon{% endblock %}

{% block navigation %} {% endblock %}

{% block content %}

    <div class="widget admin-logon">
        <img alt="Driebit Ginger" class="logon-logo" src="/lib/images/ginger-logo.png">
        <div id="logon_box" class="widget-content">
            <div id="logon_error" class="alert alert-block alert-error"></div>
            {% include "_logon_form.tpl" page=page|default:"/admin" hide_title %}
        </div>
        <div class="logon_bottom">
            <ul id="logon_methods">
                {% all include "_logon_extra.tpl" %}
            </ul>
            {% all include "_logon_link.tpl" %}
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