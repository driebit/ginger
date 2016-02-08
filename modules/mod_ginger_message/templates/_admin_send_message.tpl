{% extends "admin_edit_widget_std.tpl" %}
{% block widget_title %}{_ Send _}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}sidebar-send{% endblock %}

{% block widget_content %}
<fieldset>
    <div class="row">
        <div class="col-md-12">
            <h4>{_ Category _}</h4>
            {% with m.category.person.tree_flat as tree %}
                {% for category in tree %}
                    {% include "_admin_send_message_options.tpl" category=category %}
                {% endfor %}
            {% endwith %}

            {% block custom_options %}
            {% endblock %}

            {% wire id="send-message" type="click" postback={sendmessage message=id} delegate="resource_message_send_message" %}
            <button id="send-message" class="btn btn-default btn-sm">{_ Send _}</button>
            <div id="send-message-response"></div>
        </div>
    </div>
</fieldset>
{% endblock %}
