{% if m.acl.user %}

    {% with m.rsc[m.acl.user] as user %}

        {% block logged_in_as %}
            <p class="profile-menu__logged-in-as" >{_ Ingelogd als _}</p>
        {% endblock %}

        {% block avatar %}
            <div class="profile-menu__avatar">
                {% include 
                    "avatar/avatar.tpl" 
                    id=m.rsc[m.acl.user]
                %}
            </div>
        {% endblock %}

        {% block title %}
            {{ user.title }}
        {% endblock %}

        {% block log_off %}
            <p class="profile-menu__log-off">
                <a href="{% url logoff %}">{{ logoff_label|if_undefined:_"Uitloggen" }} <i class="#"></i> </a>
            </p>
        {% endblock %}
    
    {% endwith %}


{% endif %}
