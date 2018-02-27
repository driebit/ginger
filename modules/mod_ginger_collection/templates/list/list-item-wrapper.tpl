{% if not result_row|is_number %}
    {# Elasticsearch document #}
    {% if item._type == "resource" %}
        {# A Zotonic resource #}
        {% catinclude list_item_template result_row._id %}
    {% else %}
        {# An Elasticsearch document #}
        {% include "collection/" ++ list_item_template item=result_row query_id=query_id current=row %}
    {% endif %}
{% endif %}
