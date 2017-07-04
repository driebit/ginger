<h3>{_ Keywords _}</h3>

{% for uri in ["http://nl.dbpedia.org/resource/Boeier", "http://nl.dbpedia.org/resource/Tjotter"] %}
    {% with m.dbpedia.nl[uri] as dbpedia %}
        {% with m.rdf[dbpedia] as rdf %}
            {% include "collection/block/keyword-small.tpl" rdf=rdf %}
        {% endwith %}
    {% endwith %}
{% endfor %}
