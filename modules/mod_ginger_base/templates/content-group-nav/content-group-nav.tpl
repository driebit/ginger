
{% with m.rsc[id.content_group_id] as content_group %}
{% with content_group!=undefined and content_group.name!="system_content_group" and content_group.name!="default_content_group" as has_cg %}

{% if has_cg %}

    <div class="content-group-nav {{ extraClasses }} do_content_group_nav">

        {% block banner %}
            {% include "content-group-nav/content-group-nav-banner.tpl" %}
        {% endblock %}

        {% block subnav %}
            {% include "content-group-nav/content-group-nav-subnav.tpl" %}
        {% endblock %}

    </div>

{% endif %}

{% endwith %}
{% endwith %}