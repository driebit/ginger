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

        {% if (id|is_a:"location" or id|is_a:"organization") and (id.address_city or (id.pivot_location_lat and id.pivot_location_lng)) %}
            {% include "map/map-location.tpl" 
                id=id 
                type=maptype 
                main_content_class=main_content_class 
                fallback 
                recenter 
                blackwhite 
            %}
        {% elseif id.category.is_a.location_query %}
            <div class="do_masthead_map masthead--map">
                {% include "map/map.tpl" 
                    id=id 
                    type=maptype 
                    main_content_class=main_content_class 
                    fallback 
                    recenter 
                    blackwhite 
                    result=result 
                    container=container 
                %}
            </div>
        {% else %}
            {% with 
                id.o.hasbanner[1].depiction,
                id.o.header[1].depiction,
                id.s.haspart.o.hasbanner[1].depiction,
                id.s.haspart[1].depiction

                as

                hasbanner,
                header,
                haspart_banner,
                haspart
            %}
                {% if hasbanner.width > 500 or header.width > 500 %}
                    {% with hasbanner.id|default:header.id as dep %}
                        {% include "masthead/masthead_container.tpl" dep=dep %}
                    {% endwith %}
                {% elseif id.depiction.width > 500 and not (id.category.is_a.person or id.category.is_a.media) %}
                    {% with id.depiction.id as dep %}
                        {% if id.depiction.id|is_a:`video` %}
                            <div class="masthead--video">
                                {% include "masthead/video.tpl" dep=id.depiction %}
                            </div>
                        {% else %}
                            {% include "masthead/masthead_container.tpl" dep=dep %}
                        {% endif %}
                    {% endwith %}
                {% elseif haspart_banner.width > 500 or haspart.width > 500 %}
                    {% with haspart_banner.id|default:haspart.id as dep %}
                        {% include "masthead/masthead_container.tpl" dep=dep %}
                    {% endwith %}
                {% else %}
                    <div class="masthead {{ extraClasses }}"></div>
                {% endif %}      
            {% endwith %}
        {% endif %}

    {% endif %}

{% endwith %}
