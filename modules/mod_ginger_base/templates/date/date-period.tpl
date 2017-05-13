{% with
    start|default:m.rsc[id][name ++ "_start"],
    end|default:m.rsc[id][name ++ "_end"],
    format,
    separator|default:" – ",
    date_template|default:"date/date.tpl"
as
    start,
    end,
    format,
    separator,
    date_template
%}
    {% include date_template date=start format=format name=name ++ "_start" %}{% if start and end %}{{ separator }}{% endif %}{% include date_template date=end format=format name=name ++ "_end" %}
{% endwith %}
