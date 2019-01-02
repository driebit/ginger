<div class="person-profile">
    {% if id.o.hasprofilepicture %}
        {% image id.o.hasprofilepicture[1].id mediaclass="avatar" class=image_class %}
    {% elif id.depiction %}
        {% image id.depiction.id mediaclass="avatar" class=image_class %}
    {% elif m.rsc.person.depiction %}
        {% image m.rsc.person.depiction.id mediaclass="avatar" class=image_class %}
    {% elif m.rsc.custom_avatar_fallback.depiction %}
        {% image m.rsc.custom_avatar_fallback.depiction mediaclass="avatar" class=image_class %}
    {% endif %}
</div>
