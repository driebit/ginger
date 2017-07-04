<section class="adlib-object__keywords">
    <div class="adlib-object__keywords-header">
        <h2>{_ Keywords _}</h2>
    </div>

    <ul class="list">
    {% for uri in uris|slice:[,3] %}
        {% if m.poolparty.dbpedia_uri[uri] as dbpedia_uri %}
            {% with m.dbpedia.nl[dbpedia_uri] as dbpedia %}
                {% with m.rdf[dbpedia] as rdf %}
                    {% include "collection/block/keyword-small.tpl" rdf=rdf %}
                {% endwith %}
            {% endwith %}
        {% endif %}
    {% endfor %}
    </ul>
</section>

