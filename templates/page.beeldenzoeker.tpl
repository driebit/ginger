{% extends "base-beeldenzoeker.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main role="main" data-page-id="{{ id }}">
        <div class="home__header do_parallax" style="background-image: url({% image_url banner.id width="1600" height="400" crop=banner.crop_center quality="80" %}); background-size: cover;">
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
                suggestionsclass="page-search__suggestions"
                iconclass="icon--search"
            %}
        </div>

        <article class="main-content">

            {% include "summary/summary.tpl" id=id %}

            {% include "body/body.tpl" id=id %}

            {% include "home/home-buttons.tpl" id=id %}
        </article>

        {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="kat"}] as results %}
            {% for result in results %}

                <b>{{ result._source.title }} </b>
                {% for dimension in result._source.dimension %}
                    {# Test nested values #}
                    {{ dimension['dimension.type']}}: {{ dimension['dimension.value']}} {{ dimension['dimension.unit']}}
                {% endfor %}
                priref: {{ result._source.priref }}<br>
            {% endfor %}
        {% endwith %}

        {# Een selectie uit de collectie #}

        {# Uitgelicht is_feautred #}

        {% if id.o.haspart %}
            {% for r in id.o.haspart %}
                {% if r.o.haspart %}
                    {% with m.search[{ginger_search hassubject=[r,'haspart'] sort="+seq" pagelen=6}] as result %}

                        {% include "list/list-header.tpl" id=id list_title=r.title items=result %}

                        {% include "list/list.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id %}

                    {% endwith %}

                {% else %}

                    {% with m.search[{ginger_search query_id=r sort="-rsc.pivot_date_start" pagelen=6 page=q.page}] as result %}

                        {% include "list/list-header.tpl" id=r list_title=r.title items=result %}

                        {% include "list/list.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id %}

                    {% endwith %}
                {% endif %}
            {% endfor %}
        {% endif %}
    </main>
{% endwith %}
{% endblock %}
