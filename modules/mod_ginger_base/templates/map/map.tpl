
{% block map %}

    <div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="do_googlemap map_canvas {{ class }}"

    {% if items|length > 0 %}

        data-locations='
        [
            {% for id in items %}
                {% if id.location_lat and id.location_lng %}
                    {
                        "lat": "{{ id.location_lat }}",
                        "lng": "{{ id.location_lng }}",
                        "zoom": "{{ id.location_zoom_level }}",
                        "content": {% include "map/map-content.tpl" id=id %}
                    }
                    {% if forloop.last == "false" %},{% endif %}
                {% endif %}
            {% endfor %}
        ]'

        data-mapoptions='
            {
                "scrollwheel": {{ scrollwheel }},
                "blackwhite": {{ blackwhite }}
            }
        '

    {% endif %}

   ></div>
{% endblock %}