{% with
    m.rsc[id][name ++ "_month"],
    name ++ #month
as
    current,
    id
%}
    <label class="control-label" for="{{ id }}">{_ Month _}</label>
    <select class="form-control" name="{{ name }}_month" id="{{ id }}">
        <option value="0"{% if current == 0 %} selected{% endif %}></option>
        <option value="1"{% if current == 1 %} selected{% endif %}>{_ January _}</option>
        <option value="2"{% if current == 2 %} selected{% endif %}>{_ February _}</option>
        <option value="3"{% if current == 3 %} selected{% endif %}>{_ March _}</option>
        <option value="4"{% if current == 4 %} selected{% endif %}>{_ April _}</option>
        <option value="5"{% if current == 5 %} selected{% endif %}>{_ May _}</option>
        <option value="6"{% if current == 7 %} selected{% endif %}>{_ June _}</option>
        <option value="7"{% if current == 7 %} selected{% endif %}>{_ July _}</option>
        <option value="8"{% if current == 8 %} selected{% endif %}>{_ August _}</option>
        <option value="9"{% if current == 9 %} selected{% endif %}>{_ September _}</option>
        <option value="10"{% if current == 10 %} selected{% endif %}>{_ October _}</option>
        <option value="11"{% if current == 11 %} selected{% endif %}>{_ November _}</option>
        <option value="12"{% if current == 12 %} selected{% endif %}>{_ December _}</option>
    </select>
{% endwith %}
