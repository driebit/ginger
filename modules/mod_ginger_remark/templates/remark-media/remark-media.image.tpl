<figure class="align-{{ align }}" >

    {% if link %}
         <a href="{{ id.page_url }}" class="media--image {{ extraClasses }}
        "
        {% if id.title %}
            title="{{ id.title }}"
        {% elif id.summary %}
            title = "{{ id.summary }}"
        {% endif %}
        >
    {% else %}
        <a href="{% image_url id.id %}" class="media--image__lightbox lightbox" rel="body" title="{{ caption|default:m.rsc[id].summary }}">
    {% endif %}
        {% if first %}
            {% if id.medium.width > 750 %}
                {% image id.id mediaclass="landscape-"++sizename alt=id.title crop=id.crop_center %}
            {% elif id.medium.height > 750 %}
                 {% image id.id mediaclass="portrait-"++sizename alt=id.title crop=id.crop_center %}
            {% elif sizename %}
                {% image id.id mediaclass="landscape-"++sizename alt=id.title crop=id.id.crop_center %}
            {% else %}
                {% image id.id mediaclass="landscape-large" alt=id.title crop=id.id.crop_center %}
            {% endif %}
        {% else %}
            {% image id.id mediaclass="pager-thumbnail" alt=id.title crop=id.id.crop_center %}
        {% endif %}
        </a>

    {% if first %}
        {% if caption|default:m.rsc[id].summary as caption %}
            <figcaption><p>{{ caption }}{% if m.rsc[id].o.author %} {_ By: _} <a href="{{ m.rsc[m.rsc[id].o.author[1]].page_url }}">{{ m.rsc[m.rsc[id].o.author[1]].title }}</a>{% endif %}</p> {% include "copyrights/copyrights.tpl" %}</figcaption>
        {% endif %}
    {% endif %}

    {% if id.is_editable %}
        <a href="#" class="btn--delete depiction-delete" data-id="{{ id.id }}" title="{_ Delete image _}"><i class="icon--bin"></i></a>
    {% endif %}
</figure>

{% wire name="rsc_delete_"++id action={dialog_delete_rsc id=id on_success={script script="$(document).trigger('depiction:deleted', [" ++ id ++ ", "++ remark_id ++"]);"}} %}
