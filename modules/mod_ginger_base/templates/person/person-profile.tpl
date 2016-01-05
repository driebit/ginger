
<div class="person-profile">

    {% if id.o.hasprofilepicture %}
        {% image id.o.hasprofilepicture[1].id mediaclass="avatar" class=image_class %}
    {% elif id.depiction %}
        {% image id.depiction.id mediaclass="avatar" class=image_class %}
    {% elif m.rsc.person.depiction %}
        {% image m.rsc.person.depiction.id mediaclass="avatar" class=image_class %}
    {% elif m.rsc.fallback_profile.depiction %}
        {% image m.rsc.fallback.depiction.id mediaclass="avatar" class=image_class %}
    {% endif %}

</div>

