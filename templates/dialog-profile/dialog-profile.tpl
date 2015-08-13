{% if m.acl.user %}

    {% with m.rsc[m.acl.user] as user %}
    {% with m.rsc[m.acl.user].depiction as image_dep %}

        {% block logged_in_as %}
            <p class="profile-menu__logged-in-as" >{_ Ingelogd als _}</p>
        {% endblock %}

        {% block avatar %}
            <div class="profile-menu__avatar">
                {% include 
                    "avatar/avatar.tpl" 
                    href=user.page_url
                    label=user.title
                    class=""
                    image_dep=image_dep
                    image_class="avatar"
                %}
            </div>
        {% endblock %}

        {% block log_off %}
            <p class="profile-menu__log-off">
                <a href="{% url logoff %}">{{ logoff_label|if_undefined:_"Uitloggen" }} <i class="#"></i> </a>
            </p>
        {% endblock %}
    
    {% endwith %}
    {% endwith %}

{% endif %}
