{% extends "depiction/with_depiction.tpl" %}

{% block with_depiction %}

<li class="list-item" style="display: inline-block; height: 300px; width: 300px; border: 2px solid blue">
    
    <a href="{{ id.page_url }}" class=" {{ extraClasses }}">

        {% image dep_rsc.id mediaclass="list-image" class="img-responsive" alt="" title="" crop=dep_rsc.crop_center %}
       
        <div class="">

            <span>
                {% if id.short_title %}
                    {{ id.short_title }}
                {% else %}
                    {{ id.title }}
                {% endif %}
            </span>

            <div>
                CAT: {{ id.category.name }}
            </div>

            <p>
                {% if id.summary %}
                    {{ id.summary|striptags|truncate:200 }}
                {% else %}
                    {{ id.body|striptags|truncate:200 }}
                {% endif %}
            </p>
            
        </div>
    </a>

</li>

{% endblock %}
