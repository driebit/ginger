{% with
    date,
    (granularity == "day" or granularity == "month")|if:(date|date:"n"):"",
    name ++ #month
as
    date,
    value,
    html_id
%}
    <label class="control-label" for="{{ html_id }}">{_ Month _}</label>
    <select class="form-control" name="dt:m:1:{{ name }}" id="{{ html_id }}">
        <option{% if value == "" %} selected{% endif %}></option>
        <option value="1"{% if value == 1 %} selected{% endif %}>{_ Jan _}</option>
        <option value="2"{% if value == 2 %} selected{% endif %}>{_ Feb _}</option>
        <option value="3"{% if value == 3 %} selected{% endif %}>{_ Mar _}</option>
        <option value="4"{% if value == 4 %} selected{% endif %}>{_ Apr _}</option>
        <option value="5"{% if value == 5 %} selected{% endif %}>{_ May _}</option>
        <option value="6"{% if value == 6 %} selected{% endif %}>{_ June _}</option>
        <option value="7"{% if value == 7 %} selected{% endif %}>{_ July _}</option>
        <option value="8"{% if value == 8 %} selected{% endif %}>{_ Aug _}</option>
        <option value="9"{% if value == 9 %} selected{% endif %}>{_ Sep _}</option>
        <option value="10"{% if value == 10 %} selected{% endif %}>{_ Oct _}</option>
        <option value="11"{% if value == 11 %} selected{% endif %}>{_ Nov _}</option>
        <option value="12"{% if value == 12 %} selected{% endif %}>{_ Dec _}</option>
    </select>
{% endwith %}
