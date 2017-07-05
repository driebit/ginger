{% if record['dcterms:creator']|first as creator %}
    {% with
        m.rkd.record[creator['@id']],
        m.rdf[m.search[{dbpedia lang="nl" rkd_uri=creator['@id']}]|first]
    as
        rkd_artist,
        dbpedia
    %}
        <article class="adlib-object__creator">

            <h5 class="adlib-object__section-label">
                {_ Creator _}
            </h5>

            <section class="adlib-object__creator-image">
                {% if dbpedia.thumbnail %}
                    <img
                        src="{{ dbpedia.thumbnail }}"
                        alt="{{ creator.title }}">
                {% endif %}
            </section>

            <section class="adlib-object__creator-title">
                <div>
                    <h6>{{ rkd_artist.kwalificatie|first }}</h6>
                    <h3>{{ rkd_artist.virtualFields.hoofdTitel.kunstenaarsnaam.contents }}</h3>
                    <p>
                        {{ rkd_artist.geboorteplaats }}, {{ rkd_artist.geboortedatum_begin|isodate:"j F Y" }} –
                        {% if rkd_artist.geboorteplaats != rkd_artist.sterfplaats %}{{ rkd_artist.sterfplaats }}, {% endif %}{{ rkd_artist.sterfdatum_begin|isodate:"j F Y" }}
                    </p>
                </div>
            </section>

            <section class="adlib-object__creator-body">
                <p>{{ dbpedia.abstract }}</p>
            </section>

            {% if rkd_artist %}
                {% include "beeldenzoeker/readmore.tpl" source="RKD" url=rkd_artist.permalink text="Lees meer" class="adlib-object__creator-readmore"%}
            {% endif %}

            {% if dbpedia['http://xmlns.com/foaf/0.1/isPrimaryTopicOf'] as wikipedia_url %}
                {% include "beeldenzoeker/readmore.tpl" source="Wikipedia" url=wikipedia_url text="Lees meer" class="adlib-object__creator-readmore"%}
            {% endif %}
        </article>
    {% endwith %}
{% endif %}
