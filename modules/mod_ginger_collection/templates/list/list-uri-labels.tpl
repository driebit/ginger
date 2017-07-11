<ul>
{% for item in items %}
    <li>
    {% if item['@id'] as uri %}
        {% if
            (m.erfgoedthesaurus[uri].definition|filter:`language`:"dut"|first)
        as
            erfgoedthesaurus_definition
        %}
            {% with #list ++ forloop.counter as i %}
                <dl id="do_expand--parent-{{ i }}">
                    <dd class="do_expand" data-content="do_expand--content-{{ i }}" data-parent="do_expand--parent-{{ i }}">{{ item['rdfs:label'] }}</dd>
                    <dd id="do_expand--content-{{ i }}" class="do_expand--content">{{ erfgoedthesaurus_definition.value }} </dd>
                </dl>
            {% endwith %}
        {% else %}
            <li>
                {% include "collection/metadata/meta-link.tpl" href=item['@id'] content=item['rdfs:label']|default:item['@id']  %}
            </li>
        {% endif %}
    {% else %}
        {{ item['rdfs:label'] }}
    {% endif %}
    </li>
    {% endfor %}
</ul>
