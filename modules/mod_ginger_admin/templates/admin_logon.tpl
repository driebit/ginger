{% overrules %}

{% block bodyclass %}noframe t-login{% endblock %}

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
