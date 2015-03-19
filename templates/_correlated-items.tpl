{% if variant %}
    <aside class="ginger-correlated-items--{{ variant }} do_ginger_default_correlated_items">
{% else %}
    <aside class="ginger-correlated-items do_ginger_default_correlated_items">
{% endif %}

    <header class="ginger-correlated-items__header">
        <h3 class="ginger-correlated-items__title">{{ title }}</h3>

        <nav class="ginger-correlated-items__navigation">
            <ul>
                <li class="ginger-correlated-items__navigation-item--tiles is-shown" data-show-section="tiles"><button type="button" >Tegels</button>
                <li class="ginger-correlated-items__navigation-item--list" data-show-section="list"><button type="button">Lijst</button></li>
            </ul>
        </nav>
    </header>


    <div class="ginger-correlated-items__tiles-wrapper is-shown" data-section="tiles">
        <ol class="ginger-correlated-items__tiles">
            {% for item in items %}
                {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="tile" %}
            {% endfor %}
        </ol>
    </div>

    <ol class="ginger-correlated-items__list" data-section="list">
        {% for item in items %}
            {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="list-item" %}
        {% endfor %}
    </ol>
</aside>
