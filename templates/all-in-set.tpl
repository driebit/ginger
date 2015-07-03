{% extends "page.query.tpl" %}

{% block queryResults %}

    {% if q.direction == 'subject' %}
        {% with m.search.paged[{query hassubject=[q.id, q.type] pagelen=24 page=q.page}] as result %}
            {% if result %}
                {% pager id=id result=result hide_single_page=1 %}

                {% include "_correlated-items.tpl" items=result title="" %}
            {% else %}
                <p class="query-results__no-results">{_ Geen resultaten _}</p>
            {% endif %}
        {% endwith %}

    {% elseif q.direction == 'object' %}
        {% with m.search.paged[{query hasobject=[q.id, q.type] pagelen=24 page=q.page}] as result %}
            {% if result %}
                {% pager id=id result=result hide_single_page=1 %}

                {% include "_correlated-items.tpl" items=result title="" %}
            {% else %}
                <p class="query-results__no-results">{_ Geen resultaten _}</p>
            {% endif %}
        {% endwith %}
    {% endif %}
{% endblock %}
