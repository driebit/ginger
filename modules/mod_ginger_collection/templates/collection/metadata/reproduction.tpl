{% if record['foaf:depiction']|object_is_visible|first as reproduction %}
    <div class="adlib-object__meta__row">
        <div class="adlib-object__meta__title">
            {_ Reproduction _}
        </div>
        <dl class="adlib-object__meta__data">
            {% if reproduction['dcterms:creator'] as creator %}
                <dt>{_ Reproduction creator _}</dt>
                <dd>{{ creator }}</dd>
            {% endif %}
        </dl>
    </div>
{% endif %}
