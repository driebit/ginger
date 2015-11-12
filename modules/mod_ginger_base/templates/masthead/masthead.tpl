
{% with
    main_content_class|default:"foldout",
    maptype|default:"map",
    recenter|default:"true",
    blackwhite|default:"true",
    main_content_class|default:"foldout"
as
    main_content_class,
    maptype,
    recenter,
    blackwhite,
    main_content_class
%}

    {% if id %}

        {% if id.category.is_a.location %}

            {% include "map/map-location.tpl" id=id type=maptype main_content_class=main_content_class fallback recenter blackwhite %}

        {% elif id.category.is_a.person %}
        {# TODO: dit netjes maken #}
            {% with
                id.o.hasbanner[1].depiction|default:id.o.header[1].depiction as banner %}
                {% if banner %}
                    {% if banner.width > 500 %}
                        <div class="masthead do_parallax" style="background-image: url({% image_url banner.id mediaclass='masthead' crop %}); background-size: cover;"></div>
                    {% else %}
                        <div class="masthead"></div>
                    {% endif %}
                {% else %}
                    <div class="masthead"></div>
                {% endif %}
            {% endwith %}

        {% else %}

            {% with
                id.o.hasbanner[1].depiction|default:id.o.header[1].depiction|default:id.depiction as banner %}
                {% if banner %}
                    {% if banner.width > 500 %}
                        <div class="masthead do_parallax" style="background-image: url({% image_url banner.id mediaclass='masthead' crop %}); background-size: cover;"></div>
                    {% else %}
                        <div class="masthead"></div>
                    {% endif %}
                {% else %}
                    <div class="masthead"></div>
                {% endif %}
            {% endwith %}

        {% endif %}

    {% endif %}

{% endwith %}
