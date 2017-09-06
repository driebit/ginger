<ul>
{% for item in items %}
    <li>
    {% if item['@id'] as uri %}
        {% if
            m.rdf[m.erfgoedthesaurus[uri]]['http://www.w3.org/2004/02/skos/core#scopeNote']
        as
            erfgoedthesaurus_definition
        %}
            {% with #list ++ forloop.counter as i %}
                <dl id="do_expand--parent-{{ i }}">
                    <dd class="do_expand" data-content="do_expand--content-{{ i }}" data-parent="do_expand--parent-{{ i }}">{{ item['rdfs:label'] }}</dd>
                    <dd id="do_expand--content-{{ i }}" class="do_expand--content">{{ erfgoedthesaurus_definition }} </dd>
                </dl>
            {% endwith %}
        {% else %}
            <li>{{ item['rdfs:label'] }}</li>
        {% endif %}
    {% else %}
        {{ item['rdfs:label'] }}
    {% endif %}
    </li>
    {% endfor %}
</ul>
