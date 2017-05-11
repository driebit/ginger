<ul>
{% for item in items %}
    {% if item['@id'] as uri %}
        {% if
            (m.erfgoedthesaurus[uri].definition|filter:`language`:"dut"|first)
        as
            erfgoedthesaurus_definition
        %}
            {% with forloop.counter as i %}
                <dl id="do_expand--parent-{{ i }}">
                    <dt class="do_expand" data-content="do_expand--content-{{ i }}" data-parent="do_expand--parent-{{ i }}">{{ item['rdfs:label'] }}</dt>
                    <dd id="do_expand--content-{{ i }}" class="do_expand--content">{{ erfgoedthesaurus_definition.value }} </dd>
                </dl>
            {% endwith %}
        {% else %}
            <li>
                <a href="">{{ item['rdfs:label']|default:item['@id'] }}</a>
            </li>
        {% endif %}
    {% else %}
        <li>{{ item['rdfs:label'] }}</li>
    {% endif %}
{% endfor %}
</ul>
