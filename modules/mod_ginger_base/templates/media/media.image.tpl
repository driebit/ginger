{% with
    caption|default:m.rsc[id].summary,
    (sizename == "middle")|if:"medium":sizename
as
    caption,
    sizename
%}
<figure class="align-{{ align }}" >
    {% if link_url %}
         <a href="{{ link_url }}" class="media--image {{ extraClasses }}" target="_blank">
    {% elseif link %}
         <a href="{{ id.page_url }}" class="media--image {{ extraClasses }}"{% if id.title %}title="{{ id.title }}"{% elif caption %}title = "{{ caption }}"{% endif %}>
    {% else %}
        <a href="{% image_url id.id %}" class="media--image__lightbox lightbox" rel="body" title="{{ caption }}">
    {% endif %}

        {% if id.medium.width > 750 %}
            {% image id.id mediaclass="landscape-"++sizename alt=id.title crop=id.crop_center %}
        {% elif id.medium.height > 750 %}
             {% image id.id mediaclass="portrait-"++sizename alt=id.title crop=id.crop_center %}
        {% elif sizename %}
            {% image id.id mediaclass="landscape-"++sizename alt=id.title crop=id.id.crop_center %}
        {% else %}
            {% image id.id mediaclass="landscape-large" alt=id.title crop=id.id.crop_center %}
        {% endif %}

        </a>
    {% block figcaption %}
        {% include "media/_caption.tpl" %}
    {% endblock %}
</figure>
{% endwith %}
