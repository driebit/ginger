{% with
    date|default:m.rsc[id][name],
    granularity|default:m.rsc[id][name ++ "_granularity"]|default:"day",
    class|default:"col-md-2"
as
    date,
    granularity,
    class
%}
    <input type="hidden" name="{{ name }}_granularity" value="{{ granularity }}">

    <div class="{{ class }}">
        {% include "date/edit-day.tpl" %}
    </div>

    <div class="{{ class }}">
        {% include "date/edit-month.tpl" %}
    </div>

    <div class="{{ class }}">
        {% include "date/edit-year.tpl" %}
    </div>
{% endwith %}
