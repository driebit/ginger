{% with id.depiction as dep %}
    {% if m.rsc[dep.id].is_a.document %}
        {% catinclude "_media_item.tpl" dep.id %}
    {% elif m.rsc[dep.id].is_a.video %}
        <a href="{{ dep.id.page_url }}">
            {% include "_media_item.tpl" id=dep.id %}
        </a>
    {% endif %}
{% endwith %}