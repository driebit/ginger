{% with
    items,
    headline|default:id.title,
    type|default:default,
    text|default:id.summary,
    start_date|default:"1980,1,1",
    timenav_position|default:"top",
    start_at_slide|default:"0"
as
    items,
    headline,
    type,
    text,
    start_date,
    timenav_position,
    start_at_slide
%}

    <div class="timeline">
        <div id="{{ #ginger_timeline }}"></div>
    </div>

    {% javascript %}

        var data = {
            "title": {
                "text": {
                    "headline": "{{ headline }}"
                }
            },
            "events": [
                {# Each Timeline event must have at least a start year #}
                {% for item in items|filter:`date_start` %}
                    {
                        {% catinclude "timeline/_text.tpl" item %}
                        {% catinclude "timeline/_date.tpl" item name="start_date" date=item.date_start %}
                        {% catinclude "timeline/_date.tpl" item name="end_date" date=item.date_end %}
                        {% catinclude "timeline/_media.tpl" item %}
                    }{% if not forloop.last %},{% endif %}
                {% endfor %}
            ]
        };

        var options = {
            "language": "{{ z_language }}",
            "start_at_slide": "{{ start_at_slide }}",
            "timenav_position": "{{ timenav_position }}"
        };

        var timeline = new TL.Timeline('{{ #ginger_timeline }}', data, options);

    {% endjavascript %}

{% endwith %}
