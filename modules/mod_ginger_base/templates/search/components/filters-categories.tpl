{% with m.rsc.search_categories.o.haspart as results %}
{% if results %}
    <ul class="do_search_cmp_filters_categories">

    {% for id in results %}
        <li><label for=""><input name="{{ id.title }}" type="checkbox" value="{{ id.name }}">{{ id.title }}</label></li>
    {% endfor %}

    </ul>
{% endif %}
{% endwith %}