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
                    <div class="home-collections">
                        <h2 class="home-section__title">{{ r.title }}</h2>

                        {% include "list/list.tpl" class="list-carousel" items=r.o.haspart id=id hide_showmore_button list_id="list-"++r.id %}
                    </div>
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

        <div class="home-latest">
            <div class="main-container">
                <h2 class="home-section__title">Recent toegevoegd</h2>
                {% with m.search[{beeldenzoeker page=q.page index=m.config.mod_ginger_adlib_elasticsearch.index.value ++ "," ++ m.config.mod_elasticsearch.index.value sort=sort text=text|default:q.qs cat="beeldenzoeker_query" pagelen=15}] as result %}
                    {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button dispatch_pager="beeldenzoeker" list_template="list/list-item-beeldenzoeker.tpl" %}

                    <div id="more-results">
                        {% wire name="moreresults" action={replace target="more-results" template="beeldenzoeker/_home-more-results.tpl" page=2 } %}
                    </div>
                {% endwith %}
            </div>
        </div>

    </main>
{% endwith %}
{% endblock %}
