
{% block map %}
    {% with con tent_template|default:"map/map-content.tpl" as content_template %}

    {% if items|length > 0 %}
        <div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="do_googlemap map_canvas {{ class }}"

            data-locations='
                {% filter replace:"'":"\\&#39;" %}
                    [
                        {% for id, event_ids in items %}
                            {
                                "lat": "{{ id.location_lat }}",
                                "lng": "{{ id.location_lng }}",
                                "zoom": "{{ id.location_zoom_level }}",
                                "content": {% include content_template id=id event_ids=event_ids %}
                            }
                            {% if not forloop.last %},{% endif %}
                        {% endfor %}
                    ]
                {% endfilter %}
            '

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
