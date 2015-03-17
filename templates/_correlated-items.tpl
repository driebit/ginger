<aside class="ginger-correlated-items do_ginger_default_correlated_items">
    <header class="ginger-correlated-items__header">
        <h3 class="ginger-correlated-items__title">Aankomende Evenementen</h3>

        <nav class="ginger-correlated-items__navigation">
            <ul>
                <li><button type="button" class="ginger-correlated-items__navigation-item__tiles" data-show-section="tiles">Tegels</button>
                <li><button type="button" class="ginger-correlated-items__navigation-item__list" data-show-section="list">Lijst</button></li>
            </ul>
        </nav>
    </header>


    <ol class="ginger-correlated-items__tiles" data-section="tiles">
        {% for item in items %}
            {% include "_correlated-items_tile.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item %}
        {% endfor %}
    </ol>
    {#
    <ol class="ginger-correlated-items__list" data-section="list">
        {% for id in items %}
            <li class="ginger-correlated-items__list-item">{% catinclude "_item.tpl" id mediaclass="img-related" class="is-related col-xs-12 col-sm-6 col-md-4" %}</li>
        {% endfor %}
    </ol>
    #}
</aside>
