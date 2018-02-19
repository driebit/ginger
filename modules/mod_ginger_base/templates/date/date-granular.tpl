{% with
    date|default:m.rsc[id][name],
    granularity|default:m.rsc[id][name ++ "_granularity"]
as
    date,
    granularity
%}
    {% block before_date %}{% endblock %}

    {% if granularity == "day" %}
        {% include "date/date.tpl" %}
    {% elseif granularity == "month" %}
        <time datetime="{{ date|date:"F Y e" }}" class="{{ name }}">{{ date|date:"F Y" }}</time>
    {% elseif granularity == "year" %}
        <time datetime="{{ date|date:"Y e" }}" class="{{ name }}">{{ date|date:"Y" }}</time>
    {% endif %}
{% endwith %}
