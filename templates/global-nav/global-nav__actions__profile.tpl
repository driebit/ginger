{% if m.acl.user %}
    
    {% with #profile as profile_wire_id %} 
    {% with m.rsc[m.acl.user].depiction as image_dep %}

        {% include 
            "avatar/avatar.tpl" 
            href="#" 
            label=_"Profiel" 
            id=profile_wire_id 
            class="global-nav__actions__profile"
            image_dep=image_dep
            image_class="avatar"
        %}

    {% endwith %}
    {% endwith %} 

    {% wire
        id=#profile
        action={
            dialog_open
            title=_"Profiel"
            template="profile-menu/profile-menu.tpl"
        }
    %} 
{% endif %}


