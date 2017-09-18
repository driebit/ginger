<ul>
{% for item in items %}
    <li>
        {% include "collection/metadata/meta-link.tpl" content=item['rdfs:label']|default:item['@id'] href=item['@id'] %}
    </li>
{% endfor %}
</ul>
