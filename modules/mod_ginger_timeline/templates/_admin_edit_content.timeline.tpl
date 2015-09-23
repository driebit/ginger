{% extends "admin_edit_widget_std.tpl" %}

{% block widget_title %}{_ Timeline _}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}


{% block widget_content %}
{% with m.rsc[id] as r %}
<fieldset>
    
    <label class="control-label col-md-3" for="field-name">{_ Zoom level (-5 till 5 default -2) _}</label>
    <div class="col-md-1">
        <input class="form-control" type="text" id="field-timelinezoom" name="timelinezoom" value="{{ r.timelinezoom }}" {% if not is_editable or id == 1 %}disabled="disabled"{% endif %}/>
    </div>

</fieldset>
{% endwith %}
{% endblock %}
