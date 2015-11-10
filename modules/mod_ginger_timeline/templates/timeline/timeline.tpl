{% with
    items,
    headline|default:id.title,
    type|default:default,
    text|default:id.summary,
    start_date|default:"1980,1,1"
as
    items,
    headline,
    type,
    text,
    start_date
%}

    <div id="{{ #ginger_timeline }}"></div>

    {% javascript %}

    var data = {
        "title": {
            "text": {
                "headline": "{{ headline }}"
            }
        },
        "events": [
            {% for item in items %}
                {# Each Timeline event must have at least a start year #}
                {% if item.date_start %}
                    {
                        {% catinclude "timeline/_text.tpl" item %}
                        {% catinclude "timeline/_date.tpl" item name="start_date" date=item.date_start %}
                        {% catinclude "timeline/_date.tpl" item name="end_date" date=item.date_end %}
                        {% catinclude "timeline/_media.tpl" item %}
                    },
                {% endif %}
            {% endfor %}
        ]
    };

    var options = {
        "language": "{{ z_language }}"
    };

    var timeline = new TL.Timeline('{{ #ginger_timeline }}', data, options);

    {% endjavascript %}

{% endwith %}
