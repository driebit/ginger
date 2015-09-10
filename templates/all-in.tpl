<h1>ALL IN</h1>

{% if q.direction == 'subject' %}

    {% with m.search.paged[{query hassubject=[q.id, q.type] pagelen=24 page=q.page}] as result %}

        {{ result | pprint }}

        {% if result %}
            {% include "list/list.tpl" list_id="list--all-in" items=result extraClasses="" %}
        {% else %}
            <p class="query-results__no-results">{_ Geen resultaten _}</p>
        {% endif %}
    {% endwith %}

{% elseif q.direction == 'object' %}
    {% with m.search.paged[{query hasobject=[q.id, q.type] pagelen=24 page=q.page}] as result %}
        {% if result %}
            {% include "list/list.tpl" list_id="list--all-in" items=result extraClasses="" %}
        {% else %}
            <p class="query-results__no-results">{_ Geen resultaten _}</p>
        {% endif %}
    {% endwith %}
{% endif %}
