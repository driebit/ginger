{% with
    scrollwheel|default:"false",
    blackwhite|default:"false",
    disabledefaultui|default:"false",
    gridsize|default:"60",
    loadgeojson,
    datastyle,
    mapstyle,
    container|default:"map",
    height,
    panOffsetX|default:0,
    panOffsetY|default:0,
    noresults|default:_"No results"
as
    scrollwheel,
    blackwhite,
    disabledefaultui,
    gridsize,
    loadgeojson,
    datastyle,
    mapstyle,
    container,
    height,
    panOffsetX,
    panOffsetY,
    noresults
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
                                {% include "map/map-locations.tpl" %}
                            ]
                        {% endfilter %}
                    '

                    data-mapoptions='
                        {
                            "scrollwheel": {{ scrollwheel }},
                            "blackwhite": {{ blackwhite }},
                            "disabledefaultui": {{ disabledefaultui }},
                            "gridsize": {{ gridsize }},
                            "panOffsetX": {{ panOffsetX }},
                            "panOffsetY": {{ panOffsetY }}
                            {% if loadgeojson %},"loadgeojson": "{{ loadgeojson }}"{% endif %}
                            {% if mapstyle %},"mapstyle": {{ mapstyle }}{% endif %}
                            {% if datastyle %},"datastyle": {{ datastyle }}{% endif %}
                        }
                    '

               ></div>
            {% else %}
                {% if noresults %}
                    {% if noresults == "true" %}
                        <p class="no-results">{_ No results _}</p>
                    {% else %}
                        <p class="no-results">{{ noresults }}</p>
                    {% endif %}
                {% endif %}
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
