{% with
    m.rsc[id][name ++ "_year"],
    name ++ #year
as
    current,
    id
%}
    <label class="control-label" for="{{ id }}">{_ Year _}</label>
    <input type="text" class="form-control" name="{{ name }}_year" value="{{ current }}">
{% endwith %}
