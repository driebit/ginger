{% with
    m.rsc[id][name]|date:"Y",
    name ++ #year
as
    current,
    id
%}
    <label class="control-label" for="{{ id }}">{_ Year _}</label>
    <input type="text" id="{{ id }}" class="form-control" name="dt:y:1:{{ name }}" value="{{ current }}">
{% endwith %}
