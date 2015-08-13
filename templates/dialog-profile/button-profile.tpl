{% if m.acl.user %}
    
    {% with #profile as profile_wire_id %} 
    {% with m.rsc[m.acl.user].depiction as image_dep %}

        {% block avatar %}
            {% include 
                "avatar/avatar.tpl" 
                href="#" 
                label=_"Profiel" 
                id=profile_wire_id 
                class="button-profile"
                image_dep=image_dep
                image_class="avatar"
            %}
        {% endblock %}

    {% endwith %}
    {% endwith %} 

    {% wire
        id=#profile
        action={
            dialog_open
            title=_"Profiel"
            template="dialog-profile/dialog-profile.tpl"
        }
    %} 
{% endif %}


