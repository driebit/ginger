{% extends "admin_edit_widget_std.tpl" %}

{# Widget for adding page actions #}

{% block widget_title %}{_ Page actions _}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}sidebar-actions{% endblock %}

{% block widget_content %}
    <a href="javascript:void(0)" class="z-btn-help do_dialog" data-dialog="title: '{{ _"Help about page actions"|escapejs }}', text: '{{ _"This event is able to accept RSVP's."|escapejs }}'" title="{_ Need more help? _}"><i class="zotonic-icon-help"></i></a>
    {% with m.rsc[id] as r %}
        <div id="unlink-undo-message"></div>

        <div class="form-group">
            <label for="action_rsvp" class="checkbox-inline">
                <input type="checkbox" id="action_rsvp" name="action_rsvp" value="1" {% if r.action_rsvp %}checked="checked"{% endif %}/>
                {_ RSVP _}
            </label>
        </div>
            
    {% endwith %}
{% endblock %}