{% with
    date,
    granularity,
    name ++ #day
as
    date,
    granularity,
    id
%}
    {% with (granularity == "day")|if:(date|date:"d"):"" as value %}
        <label class="control-label" for="{{ id }}">{_ Day _}</label>
        <select class="form-control" name="dt:d:1:{{ name }}" id="{{ id }}">
            <option value=""></option>
            {% for day in 1|range:31 %}
                <option value="{{ day }}"{% if day == value %} selected{% endif %}>{{ day }}</option>
            {% endfor %}
        </select>
    {% endwith %}
{% endwith %}
