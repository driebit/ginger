{% if m.search[{linked_data uris=uris pagelen=3}] as dbpedia_uris %}

    <section class="adlib-object__keywords">
        <div class="adlib-object__keywords-header">
            <h2>{_ Keywords _}</h2>
        </div>

        <ul class="list">
            {% for dbpedia_uri in results %}
                {% with m.rdf[dbpedia_uri] as rdf %}
                    {% include "collection/block/keyword-small.tpl" rdf=rdf %}
                {% endwith %}
            {% endfor %}
        </ul>
    </section>

{% endif %}
