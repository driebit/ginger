{% extends "admin_edit_widget_std.tpl" %}

{# Widget for adding page actions #}

{% block widget_title %}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}sidebar-actions{% endblock %}

{% block widget_title %}
{_ Page actions _}
<div class="widget-header-tools">
    <a href="javascript:void(0)" class="z-btn-help do_dialog" data-dialog="title: '{{ _"Help about page actions"|escapejs }}', text: '{{ _"This event is able to accept RSVP."|escapejs }}'" title="{_ Need more help? _}"></a>
</div>
{% endblock %}

{% block widget_content %}

    {% with m.rsc[id] as r %}
        <div id="unlink-undo-message"></div>

        <div class="form-group">
            <label for="action_rsvp" class="checkbox-inline">
                <input type="checkbox" id="action_rsvp" name="action_rsvp" value="1" {% if r.action_rsvp == '1' %}checked="checked"{% endif %}/>
                {_ RSVP _}
            </label>
        </div>
        <div class="form-group">
            <label for="rsvp_max_participants">{_ maximum participants _}</label>
            <input type="text" id="rsvp_max_participants" name="rsvp_max_participants" value="{{r.rsvp_max_participants }}" size=5 />
            {% validate id="rsvp_max_participants" type={numericality not_a_number_message=_"must be a number"} %}
        </div>

    {% endwith %}
{% endblock %}
