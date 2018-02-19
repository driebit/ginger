{% if record['foaf:depiction']|object_is_visible|first as reproduction %}
    {% if reproduction['dcterms:creator'] %}
        <div class="adlib-object__meta__row">
            <h6 class="adlib-object__meta__title">
                {_ Reproduction _}
            </h6>
            <dl class="adlib-object__meta__data">
                {% if reproduction['dcterms:creator'] as creator %}
                    <dt>{_ Reproduction creator _}</dt>
                    <dd>{{ creator['rdfs:label'] }}</dd>
                {% endif %}
            </dl>
        </div>
    {% endif %}
{% endif %}
