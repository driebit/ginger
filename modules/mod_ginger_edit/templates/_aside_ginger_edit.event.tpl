<aside>

    {% if id.is_editable %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="keyword" predicate="subject" %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="location" predicate="presented_at" title=_'Location' tabs_enabled=["new","find"] tab="new" %}
        {# include "aside-connection/aside-add-connection.tpl" id=id cat="organization" predicate="organised_by" title=_'Organiser' tabs_enabled=["new","find"] tab="new" #}
        {% include "_admin_edit_content_date_range.tpl" show_header is_editable %}
    {% endif %}

</aside>
