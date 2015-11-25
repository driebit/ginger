{% with m.rsc.search_filters.o.haspart as results %}
    <ul class="do_search_cmp_filters_keywords">

    {% for id in results %}
        <li><label for=""><input name="{{ id.title }}" type="checkbox" value="{{ id.id }}">{{ id.title }}</label></li>
    {% endfor %}

    </ul>
{% endwith %}