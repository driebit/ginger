
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

        {% elseif id.category.is_a.location_query %}
            <div class="do_masthead_map masthead--map">
                {% include "map/map.tpl" id=id type=maptype main_content_class=main_content_class fallback recenter blackwhite result=result container=container %}
            </div>
        {% else %}
           {% if id.o.hasbanner[1].depiction.width > 500 or id.o.header[1].depiction.width > 500 %}
                {% with id.o.hasbanner[1].depiction.id|default:id.o.header[1].depiction.id as dep %}
                    <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url dep mediaclass='masthead' crop=dep.crop_center %}); background-size: cover;"></div>
                {% endwith %}
            {% elseif id.depiction.width > 500 and not (id.category.is_a.person or id.category.is_a.media) %}
                {% with id.depiction.id as dep %}
                    <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url dep mediaclass='masthead' crop=dep.crop_center %}); background-size: cover;"></div>
                {% endwith %}
            {% elseif id.s.haspart.o.hasbanner[1].depiction.width > 500 or id.s.haspart[1].depiction.width > 500 %}
                {% with id.s.haspart.o.hasbanner[1].depiction.id|default:id.s.haspart[1].depiction.id as dep %}
                    <div class="masthead do_parallax {{ extraClasses }}" style="background-image: url({% image_url dep mediaclass='masthead' crop=dep.crop_center %}); background-size: cover;"></div>
                {% endwith %}
            {% else %}
                <div class="masthead {{ extraClasses }}"></div>
            {% endif %}

        {% endif %}

    {% endif %}

{% endwith %}
