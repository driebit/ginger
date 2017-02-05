{% extends "base.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main role="main" data-page-id="{{ id }}">
        <div class="home__header do_parallax" style="background-image: url({% image_url banner.id mediaclass='masthead' crop %}); background-size: cover;">
            <div class="home__title">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}
            </div>
        </div>
    	{% include "search-suggestions/search-form.tpl" id=id placeholder=placeholder.title
            formclass="home-search"
            wrapperclass="home-search__container"
            buttonclass="btn--search home-search-submit"
            togglebutton="false"
            suggestionsclass="home-search__suggestions"
            iconclass="icon--search"
        %}

        <article class="main-content">

            {% include "summary/summary.tpl" id=id %}

            {% include "body/body.tpl" id=id %}

            {% include "home/home-buttons.tpl" id=id %}
        </article>
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
