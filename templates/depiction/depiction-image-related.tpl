<a href="{{ id.page_url }}">

    {% image dep_rsc.id mediaclass="list-thumbnail" class="img-responsive" alt="" crop=dep_rsc.crop_center %}
   
    <div class="">
        <span>
            {% if id.short_title %}
                {{ id.short_title }}
            {% else %}
                {{ id.title }}
            {% endif %}
        </span>

        <p>
            {% if id.summary %}
                {{ id.summary|striptags|truncate:200 }}
            {% else %}
                {{ id.body|striptags|truncate:200 }}
            {% endif %}
        </p>
    </div>

</a>
