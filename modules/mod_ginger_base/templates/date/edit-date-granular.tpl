{% with
    date|default:m.rsc[id][name],
    granularity|default:m.rsc[id][name ++ "_granularity"]|default:"day"
as
    date,
    granularity
%}
    <input type="hidden" name="{{ name }}_granularity" value="{{ granularity }}">

    <div class="col-md-2">
        {% include "date/edit-day.tpl" %}
    </div>

    <div class="col-md-2">
        {% include "date/edit-month.tpl" %}
    </div>

    <div class="col-md-3">
        {% include "date/edit-year.tpl" %}
    </div>
{% endwith %}
