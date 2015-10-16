
{% block map %}
    {% lib
        "css/map.css"
    %}
    {% with content_template|default:"map/map-content.tpl" as content_template %}

    {% if items|length > 0 %}

        <div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="do_googlemap map_canvas {{ class }}"

            data-locations='
            [
                {% for id in items|filter:`location_lat` %}
                    {% if id.location_lat and id.location_lng %}
                        {
                            "lat": "{{ id.location_lat }}",
                            "lng": "{{ id.location_lng }}",
                            "zoom": "{{ id.location_zoom_level }}",
                            "content": {% include content_template id=id %}
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

       ></div>
   {% endif %}
   {% endwith %}
{% endblock %}
