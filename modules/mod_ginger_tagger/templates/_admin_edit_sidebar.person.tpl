{% extends "admin_edit_widget_std.tpl" %}

{% block widget_title %}
    {_ RFIDs _}
    <div class="widget-header-tools">
        <a href="javascript:void(0)" class="z-btn-help do_dialog" data-dialog="title: '{_ RFIDs _}', text: '{_ Every person has one or more RFIDs. Edit the RFIDs that belong to this person. _}'" title="{_ RFIDs _}"></a>
    </div>
{% endblock %}

{% block widget_content %}
    {% live template="admin/rfids.tpl" id=id topic="~site/rsc/" ++ id ++ "/identity" %}
{% endblock %}
