
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

        {% if (id.category.is_a.location or id.category.is_a.organization) and id.address_city %}

            {% include "map/map-location.tpl" id=id type=maptype main_content_class=main_content_class fallback recenter blackwhite %}

        {% else %}

           {% if id.o.hasbanner[1].depiction.width > 500 %}
                <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url id.o.hasbanner[1].depiction.id mediaclass='masthead' %}); background-size: cover;"></div>
            {% elif id.o.header[1].depiction.width > 500 %}
                <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url id.o.header[1].depiction.id mediaclass='masthead' %}); background-size: cover;"></div>
            {% elif id.depiction.width > 500 and not (id.category.is_a.person or id.category.is_a.media) %}
                <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url id.depiction.id mediaclass='masthead' %}); background-size: cover;"></div>
            {% else %}
                <div class="masthead {{ extraClasses }}"></div>
            {% endif %}

        {% endif %}

    {% endif %}

{% endwith %}
