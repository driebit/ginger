{% with
    name,
    class|default:"col-md-2"
as
    name,
    class
%}
    <div class="{{ class }}">
        {% include "date-split/select-day.tpl" %}
    </div>

    <div class="{{ class }}">
        {% include "date-split/select-month.tpl" %}
    </div>

    <div class="{{ class }}">
        {% include "date-split/select-year.tpl" %}
    </div>
{% endwith %}
