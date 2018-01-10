{% with
    m.rsc[id][name]|date:"Y",
    name ++ #year
as
    current,
    html_id
%}
    <label class="control-label" for="{{ html_id }}">{_ Year _}</label>
    <input type="text" id="{{ html_id }}" class="form-control" name="dt:y:1:{{ name }}" value="{{ current }}">
{% endwith %}
