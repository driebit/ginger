
{% with
    scrollwheel|default:"false",
    blackwhite|default:"false",
    container,
    height|default:"600"
as
    scrollwheel,
    blackwhite,
    container,
    height
%}

    {% block map %}

        {% with content_template|default:"map/map-content.tpl" as content_template %}

            {% if items|length > 0 %}
                <div id="{{ container }}" style="height: {{ height }}px" class="do_googlemap map_canvas {{ class }}"

                    data-locations='
                        {% filter replace:"'":"\\&#39;" %}
                            [
                                {% for item in items|location_defined %}
                                 {% with item[1]|default:item as item_id %}
                                    {
                                        "lat": "{{ item_id.location_lat }}",
                                        "lng": "{{ item_id.location_lng }}",
                                        "zoom": "{{ item_id.location_zoom_level }}",
                                        "id": "{{ item_id.id }}"
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
            {% else %}
                <p class="no-results">{_ No results _}</p>
            {% endif %} 

            {% wire name="map_infobox" postback={map_infobox} delegate="mod_ginger_base" %}


        {% endwith %}
    {% endblock %}

{% endwith %}
