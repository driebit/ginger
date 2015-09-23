{% if id.is_editable %} 

    {% with id.category_id as cat_id %}
    {% with m.rsc[cat_id].name as cat_name %}
        {% if cat_name=='story' %}
            <a class="mod_ginger_nav__top-button mod_ginger_nav__main-nav__edit-button" href="/edit/{{ m.rsc[id].id }}">
                <span class="glyphicon glyphicon-edit">&nbsp;</span>
                <!-- <span>{_ Edit _}</span> -->
                <span>&nbsp;</span>
            </a>
        {% else %}
            <a class="mod_ginger_nav__top-button mod_ginger_nav__main-nav__edit-button" href="{% url admin_edit_rsc id=id %}">
                <span class="glyphicon glyphicon-edit">&nbsp;</span>
                <!-- <span>{_ Edit _}</span> -->
                <span>&nbsp;</span>
            </a>
        {% endif %}
    {% endwith %}
    {% endwith %}
{% endif %}


   