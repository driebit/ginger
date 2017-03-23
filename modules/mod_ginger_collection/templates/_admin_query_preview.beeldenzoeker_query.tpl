<ul>
{% for record in result %}
    <li class="rsc-edge">{{ record['_source']['dcterms:title'] }}</li>
{% endfor %}
</ul>
