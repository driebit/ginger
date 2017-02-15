{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main role="main" data-page-id="{{ id }}">
        <div class="home__header" style="background-image: url({% image_url banner.id width="1600" height="400" crop=banner.crop_center quality="80" %}); background-size: cover;">
            <div class="home__title">
                <h1>{{ id.title }}</h1>
                {% if id.subtitle %}
                    <h2>{{ id.subtitle }}</h2>
                {% endif %}
            </div>
        </div>
        <div class="page-search">
        	{% include "search-suggestions/search-form.tpl" id=id placeholder=placeholder.title
                formclass="page-search__search"
                wrapperclass="page-search__container"
                buttonclass="btn--search page-search-submit"
                togglebutton="false"
                buttonlabel=_"Search"
                suggestionsclass="page-search__suggestions"
                iconclass="icon--search"
            %}
        </div>

        <div class="home-selection">
            <h2 class="home-section__title">{_ A selection from the collection of _} {{ m.site.beeldenzoeker_title }}</h2>

            {# With facets: {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="vrouw" agg=['creator', 'terms', ['field', 'maker.creator.name.keyword']] pagelen="3"}] as result %} #}
            {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="vrouw" pagelen="3"}] as result %}
                {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </div>

        <div class="home-events">
            <h2 class="home-section__title">Foto's van evenementen van het museum</h2>

            {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen="3"}] as result %}
                {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </div>

        <div class="home-latest">
            <div class="main-container">
                <h2 class="home-section__title">Recent toegevoegd</h2>

                {% with m.search.paged[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen="20"}] as result %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}

                    {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}
                {% endwith %}
            </div>
        </div>

       {#  {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="kat"}] as results %}
            {% for result in results %}
                {% with result._source as record %}

                    {% for reproduction in record.reproduction %}
                        {% if reproduction['reproduction.identifier_URL'] %}

                            <img src="{{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.identifier_URL'] }}&width=100&height=100">
                        {% endif %}
                    {% endfor %}

                    <b>{{ record.title }} </b>
                    {% for dimension in record.dimension %}

                        {{ dimension['dimension.type']}}: {{ dimension['dimension.value']}} {{ dimension['dimension.unit']}}
                    {% endfor %}
                    priref: {{ record.priref }}, object: {{ record.object_number }}<br>
                {% endwith %}
            {% endfor %}
        {% endwith %} #}

        {% if id.o.haspart %}
            {% for r in id.o.haspart %}
                {% if r.o.haspart %}
                    {% with m.search[{ginger_search hassubject=[r,'haspart'] sort="+seq" pagelen=6}] as result %}

                        {% include "list/list-header.tpl" id=id list_title=r.title items=result %}

                        {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id %}

                    {% endwith %}

                {% else %}

                    {% with m.search[{ginger_search query_id=r sort="-rsc.pivot_date_start" pagelen=6 page=q.page}] as result %}

                        {% include "list/list-header.tpl" id=r list_title=r.title items=result %}

                        {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id %}

                    {% endwith %}
                {% endif %}
            {% endfor %}
        {% endif %}
    </main>
{% endwith %}
{% endblock %}
