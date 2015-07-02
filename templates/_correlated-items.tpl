{% if variant %}
    <aside class="ginger-correlated-items--{{ variant }} do_ginger_default_correlated_items">
{% else %}
    <aside class="ginger-correlated-items do_ginger_default_correlated_items">
{% endif %}

    <header class="ginger-correlated-items__header">
        <h3 class="ginger-correlated-items__title">{{ title }}</h3>

        {#
        {% block correlated_items_nav %}
        <nav class="ginger-correlated-items__navigation">
            <ul>
                <li class="ginger-correlated-items__navigation-item--tiles is-shown" data-show-section="tiles"><button type="button" >Tegels</button>
                <li class="ginger-correlated-items__navigation-item--list" data-show-section="list"><button type="button">Lijst</button></li>
            </ul>
        </nav>
        {% endblock %}
        #}
    </header>

    <div class="ginger-correlated-items__tiles-wrapper is-shown" data-section="tiles">
        <ol class="ginger-correlated-items__tiles">
            {% if useRank|is_defined and useRank == 1 %}
                {% for item, rank in items %}
                    {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="tile" %}
                {% endfor %}
            {% else %}
                {% for item in items %}
                    {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="tile" %}
                {% endfor %}
            {% endif %}
        </ol>
    </div>

    <ol class="ginger-correlated-items__list" data-section="list">
        {% if useRank|is_defined and useRank == 1 %}
            {% for item, rank in items %}
                {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="list-item" %}
            {% endfor %}
        {% else %}
            {% for item in items %}
                {% include "_correlated-items_list-item.tpl" type=showMetaData classPrefix="ginger-correlated-items" item=item showas="list-item" %}
            {% endfor %}
        {% endif %}
    </ol>

    {% if showMoreLabel %}
        <p class="ginger-correlated-items__show-more">
            {% if showMoreQueryRsc %}
                <a href="{% url page id=showMoreQueryRsc.id slug=showMoreQueryRsc.slug %}" class="ginger-btn-pill--next">{{ showMoreLabel }}</a>
            {% else %}
                <a href="{% url all_in_set type=showMoreType direction=showMoreDirection id=showMoreId %}" class="ginger-btn-pill--next">{{ showMoreLabel }}</a>
            {% endif %}
        </p>
    {% endif %}
</aside>
