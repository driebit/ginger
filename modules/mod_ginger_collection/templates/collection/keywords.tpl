{% if m.search[{linked_data uris=uris pagelen=3}] as dbpedia_rdfs %}
    <section class="adlib-object__keywords">
        <div class="adlib-object__keywords-header">
            <h2>{_ Keywords _}</h2>
        </div>

        <ul class="list">
            {% for dbpedia_rdf in dbpedia_rdfs %}
                {% with m.rdf[dbpedia_rdf] as rdf %}
                    {# Fall back to manually constructed URL for RDFs that lack isPrimaryTopicOf #}
                    {% include "collection/block/keyword-small.tpl" url=rdf['http://xmlns.com/foaf/0.1/isPrimaryTopicOf']|default:"https://nl.wikipedia.org/wiki/" ++ rdf.title %}
                {% endwith %}
            {% endfor %}
        </ul>
    </section>
{% endif %}
