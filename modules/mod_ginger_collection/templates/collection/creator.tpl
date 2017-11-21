{% if record['dcterms:creator'][1]['@id'] as creator_uri %}
    {% with
        m.rkd.record[creator_uri],
        m.rdf[m.search[{dbpedia lang="nl" rkd_uri=creator_uri}]|first]
    as
        rkd_artist,
        dbpedia
    %}
        <div class="adlib-object__creator-container">

            <h5 class="adlib-object__section-label">
                {_ Creator _}
            </h5>

            <article class="adlib-object__creator">

                <section class="adlib-object__creator-image">
                    {% if dbpedia.thumbnail %}
                        <img
                            src="{{ dbpedia.thumbnail|https }}"
                            alt="{{ creator.title }}">
                    {% endif %}
                </section>

                <section class="adlib-object__creator-title">
                    <div>
                        <h6>{{ rkd_artist.kwalificatie|first }}</h6>
                        <h3>{{ rkd_artist.virtualFields.hoofdTitel.kunstenaarsnaam.contents }}</h3>
                        <small>
                            {{ rkd_artist.geboorteplaats }}, {{ rkd_artist.geboortedatum_begin|isodate:"j F Y" }}
                            {% if rkd_artist.sterfdatum_begin != "null" %} – {% if rkd_artist.geboorteplaats != rkd_artist.sterfplaats %}{{ rkd_artist.sterfplaats }}, {% endif %}{{ rkd_artist.sterfdatum_begin|isodate:"j F Y" }}{% endif %}
                        </small>
                    </div>
                </section>

                <section class="adlib-object__creator-body">
                    <p>{{ dbpedia.abstract|default:dbpedia['http://www.w3.org/2000/01/rdf-schema#comment'] }}</p>
                </section>
            </article>

            {% if dbpedia['http://xmlns.com/foaf/0.1/isPrimaryTopicOf'] as wikipedia_url %}
                {% include "collection/readmore.tpl" source="Wikipedia" url=wikipedia_url class="adlib-object__creator-readmore"%}
            {% elseif rkd_artist %}
                {% include "collection/readmore.tpl" source="RKD" url=rkd_artist.permalink class="adlib-object__creator-readmore"%}
            {% endif %}

        </div>
    {% endwith %}
{% endif %}
