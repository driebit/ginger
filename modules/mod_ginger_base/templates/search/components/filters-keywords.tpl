{% with m.rsc.keywords_collection.o.haspart as test %}
    <ul class="do_search_cmp_filters_keywords">

    {% for id in test %}
        <li><label for=""><input name="{{ id.title }}" type="checkbox" value="{{ id.id }}">{{ id.title }}</label></li>
    {% endfor %}

    </ul>
{% endwith %}