{% with
    m.rsc[id][name ++ "_day"],
    name ++ #day
as
    current,
    id
%}
    <label class="control-label" for="{{ id }}">{_ Day _}</label>
    <select class="form-control" name="{{ name }}_day" id="{{ id }}">
        <option value="0"{% if current == 0 %} selected{% endif %}></option>
        {% for day in 1|range:31 %}
            <option value="{{ day }}"{% if day == current %} selected{% endif %}>{{ day }}</option>
        {% endfor %}
    </select>
{% endwith %}
