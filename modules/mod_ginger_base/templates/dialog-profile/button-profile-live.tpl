{% if m.acl.user %}
    {% with #profile as profile_wire_id %}

        <a href="#" id="{{ profile_wire_id }}" class="{{ class }}">
            {% include "avatar/avatar.tpl"
                id=m.rsc[m.acl.user]
                fallback_rsc_id=m.rsc.custom_avatar_fallback.id
            %}

            <span>{{ title }}</span>
        </a>

    {% endwith %}

    {% wire
        id=#profile
        action={
            dialog_open
            title=_"Profile"
            template="dialog-profile/dialog-profile.tpl"
        }
    %}
{% endif %}
