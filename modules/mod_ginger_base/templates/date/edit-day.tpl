{% with
    date,
    granularity,
    name ++ #day
as
    date,
    granularity,
    html_id
%}
    {% with (granularity == "day")|if:(date|date:"d"):"" as value %}
        <label class="control-label" for="{{ html_id }}">{_ Day _}</label>
        <select class="form-control" name="dt:d:1:{{ name }}" id="{{ html_id }}">
            <option value=""></option>
            {% for day in 1|range:31 %}
                <option value="{{ day }}"{% if day == value %} selected{% endif %}>{{ day }}</option>
            {% endfor %}
        </select>
    {% endwith %}
{% endwith %}
