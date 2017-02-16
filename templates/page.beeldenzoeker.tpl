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


        {% if id.o.haspart %}
            {% for r in id.o.haspart %}
                {% if r.o.haspart %}
                    {% with m.search[{ginger_search hassubject=[r,'haspart'] sort="+seq" pagelen=6}] as result %}
                        <div class="home-collections">
                            <h2 class="home-section__title">{{ r.title }}</h2>

                            {% include "list/list.tpl" class="list-carousel" items=result id=id hide_showmore_button list_id="list-"++r.id %}
                        </div>
                    {% endwith %}

                {% else %}

                    {% with m.search[{ginger_search query_id=r sort="-rsc.pivot_date_start" pagelen=6 page=q.page}] as result %}
                        <div class="home-collections">
                            <h2 class="home-section__title">{{ r.title }}</h2>

                            {% include "list/list.tpl" items=result id=id hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
                        </div>
                    {% endwith %}
                {% endif %}
            {% endfor %}
        {% endif %}

        {# <div class="home-events">
            <h2 class="home-section__title">Foto's van evenementen van het museum</h2>

            
            {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen=10}] as result %}
                {% include "list/list-beeldenzoeker.tpl" class="list-carousel" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </div> #}

        {# With facets: {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="vrouw" agg=['creator', 'terms', ['field', 'maker.creator.name.keyword']] pagelen="3"}] as result %} #}

        <div class="home-latest">
            <div class="main-container">
                <h2 class="home-section__title">Recent toegevoegd</h2>

                {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen=20}] as result %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}

                    {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-infinite" list_template="list/list-item-beeldenzoeker.tpl" %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}
                {% endwith %}
            </div>
        </div>


    </main>
{% endwith %}
{% endblock %}
