{% if m.acl.user %}
    
    {% with #profile as profile_wire_id %} 
  
        <a href="#" id="{{ profile_wire_id }}">
            
            {% include "avatar/avatar.tpl"
                id=m.rsc[m.acl.user]
                fallback_rsc_id=m.rsc.custom_fallback.id
            %}

            {_ Profiel _}

        </a>

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


