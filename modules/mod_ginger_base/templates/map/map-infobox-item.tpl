{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}
    <a class='infobox-item' href='{{ id.page_url }}'>
        {% if dep_rsc %}
            <div class='infobox-item__depiction' style='background-image: url({% image_url dep_rsc.id mediaclass="list-image-map" class="img-responsive" alt="" crop=dep_rsc.crop_center %})'></div>
        {% endif %}
            
        <div class='infobox-item__content'>
             <div class='infobox-item__content__category'>
                <i class='icon--{{ id.category.name }}'></i>{{ m.rsc[id.category.id].title|escape }}
            </div>
        </div>
      
    </a>
{% endblock %}
