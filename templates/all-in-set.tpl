{% extends "page.query.tpl" %}

{% block queryResults %}
    {{ q.collection|split:','|pprint }}

    {% with m.search.paged[{query query_id=[976,609,3118,3762,3907,4736,4795,4868,2106,5320,2300,
2301,5757,859,6187,2304,878,7148,7644,7732,2312,8334,
2309,8433,8876,8878,8929,9132] pagelen=24 page=q.page}] as result %}
        {% if result %}
            {% pager id=id result=result hide_single_page=1 %}

            {% include "_correlated-items.tpl" items=result title="" %}
        {% else %}
            <p class="query-results__no-results">Geen artikelen</p>
        {% endif %}
    {% endwith %}
{% endblock %}
