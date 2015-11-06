
{% with 
    scrollwheel|default:"false",
    blackwhite|default:"false",
    container
as 
    scrollwheel,
    blackwhite,
    container
%}

    {% block map %}
        {% with content_template|default:"map/map-content.tpl" as content_template %}

        {% if items|length > 0 %}

            <div id="{{ container }}" style="height: {% if height %}{{ height }}px{% else %}100%{% endif %}" class="do_googlemap map_canvas {{ class }}"

                data-locations='
                    {% filter replace:"'":"\\&#39;" %}
                        [
                            {% for item in items %}
                            {% with item[1]|default:item as item_id %}
                                {
                                    "lat": "{{ item_id.location_lat }}",
                                    "lng": "{{ item_id.location_lng }}",
                                    "zoom": "{{ item_id.location_zoom_level }}",
                                    "content": {% include content_template id=item_id item=item %}
                                }
                                {% if not forloop.last %},{% endif %}
                            {% endwith %}
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

{% endwith %}