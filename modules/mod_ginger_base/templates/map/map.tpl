{% with
    scrollwheel|default:"false",
    blackwhite|default:"false",
    disabledefaultui|default:"false",
    gridsize|default:"60",
    container,
    height
as
    scrollwheel,
    blackwhite,
    disabledefaultui,
    gridsize,
    container,
    height
%}

    {% block map %}

            {% if result|length > 0 %}

                <div id="{{ container }}" style="
                {% if height %}
                    height: {{ height }}px
                {% else %}
                    height: 100%
                {% endif %}
                 " class="do_googlemap map_canvas {{ class }}"

                    data-locations='
                        {% filter replace:"'":"\\&#39;" %}
                            [
                                {% for rid, lat, lng, cat in result %}
                                    {
                                        "lat": "{{ lat }}",
                                        "lng": "{{ lng }}",
                                        "id": "{{ rid }}",
                                        "icon": "{{ cat.o.hasicon[1].medium.filename }}"
                                    }
                                    {% if not forloop.last %},{% endif %}
                                {% endfor %}
                            ]
                        {% endfilter %}
                    '

                    data-mapoptions='
                        {
                            "scrollwheel": {{ scrollwheel }},
                            "blackwhite": {{ blackwhite }},
                            "disabledefaultui": {{ disabledefaultui }},
                            "gridsize": {{ gridsize }}
                        }
                    '

               ></div>
            {% else %}
                <p class="no-results">{_ No results _}</p>
            {% endif %} 

            {% wire name="map_infobox"
                    action={
                        postback
                        postback={
                            map_infobox
                        }
                        delegate="mod_ginger_base"
                    }
                    %}

    {% endblock %}

{% endwith %}
