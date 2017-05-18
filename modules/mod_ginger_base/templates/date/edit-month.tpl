{% with
    date,
    (granularity == "day" or granularity == "month")|if:(date|date:"n"):"",
    name ++ #month
as
    date,
    value,
    id
%}
    <label class="control-label" for="{{ id }}">{_ Month _}</label>
    <select class="form-control" name="dt:m:1:{{ name }}" id="{{ id }}">
        <option{% if value == "" %} selected{% endif %}></option>
        <option value="1"{% if value == 1 %} selected{% endif %}>{_ January _}</option>
        <option value="2"{% if value == 2 %} selected{% endif %}>{_ February _}</option>
        <option value="3"{% if value == 3 %} selected{% endif %}>{_ March _}</option>
        <option value="4"{% if value == 4 %} selected{% endif %}>{_ April _}</option>
        <option value="5"{% if value == 5 %} selected{% endif %}>{_ May _}</option>
        <option value="6"{% if value == 6 %} selected{% endif %}>{_ June _}</option>
        <option value="7"{% if value == 7 %} selected{% endif %}>{_ July _}</option>
        <option value="8"{% if value == 8 %} selected{% endif %}>{_ August _}</option>
        <option value="9"{% if value == 9 %} selected{% endif %}>{_ September _}</option>
        <option value="10"{% if value == 10 %} selected{% endif %}>{_ October _}</option>
        <option value="11"{% if value == 11 %} selected{% endif %}>{_ November _}</option>
        <option value="12"{% if value == 12 %} selected{% endif %}>{_ December _}</option>
    </select>
{% endwith %}
