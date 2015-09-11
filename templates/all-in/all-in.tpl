 {% if q.direction == 'subject' %}

        {% with m.search.paged[{query hassubject=[q.id, q.type] pagelen=24 page=q.page}] as result %}

            {% if result %}

                {% include "list/list.tpl" list_id="list--all-in" items=result extraClasses="" %}

                {% button class="list__more" text="Toon meer resultaten..." action={moreresults result=result
                    target="list--fixed-all-in"
                    template="list/list-item.tpl"}
                %}

            {% else %}
                <p class="query-results__no-results">{_ Geen resultaten _}</p>
            {% endif %}

        {% endwith %}

    {% elseif q.direction == 'object' %}
        {% with m.search.paged[{query hasobject=[q.id, q.type] pagelen=24 page=q.page}] as result %}
            {% if result %}

                {% include "list/list.tpl" list_id="list--all-in" items=result extraClasses="" %}

                {% button class="list__more" text="Toon meer resultaten..." action={moreresults result=result
                    target="list--all-in"
                    template="list/list-item.tpl"}
                %}
                
            {% else %}
                <p class="query-results__no-results">{_ Geen resultaten _}</p>
            {% endif %}
        {% endwith %}
    {% endif %}