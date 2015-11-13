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

        {% print container %}

            {% if result|length > 0 %}

                <div id="{{ container }}" style="height: {{ height }}px" class="do_googlemap map_canvas {{ class }}"

                    data-locations='
                        {% filter replace:"'":"\\&#39;" %}
                            [
                                {% for rid, lat, lng, cat in result %}
                                    {
                                        "lat": "{{ lat }}",
                                        "lng": "{{ lng }}",
                                        "id": "{{ rid }}"
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
