<a href="/image/{{ id.medium.filename }}" target="_blank" class="media--document">
    {% if id.medium.width > 750 %}
        {% image id.depiction mediaclass="landscape-large" class="img-responsive" alt="" crop=id.depiction.id.crop_center %}
    {% elif id.medium.height > 750 %}
         {% image id.depiction mediaclass="portrait-large" class="img-responsive" alt="" crop=id.depiction.id.crop_center %}
    {% else %}
        {% image id.depiction class="img-auto" alt="" crop=id.depiction.id.crop_center %}
    {% endif %}
</a>
