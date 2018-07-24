{% extends "base.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main id="main-content" data-page-id="{{ id }}">
        {% if banner %}
            {% if banner.width > 500 %}
                <div class="home__header do_parallax" style="background-image: url({% image_url banner.id mediaclass='masthead' crop %}); background-size: cover;">
            {% else %}
                <div class="home__header">
            {% endif %}
        {% else %}
            <div class="home__header">
        {% endif %}
            <div class="foldout">

                {% include "foldout/foldout-button.tpl" %}

                <div class="home__title">
                    {% include "page-title/page-title.tpl" id=id %}

                    {% include "subtitle/subtitle.tpl" id=id %}
                </div>

                <article class="main-content">

                    {% include "summary/summary.tpl" id=id %}

                    {% include "body/body.tpl" id=id %}

                    {% include "home/home-buttons.tpl" id=id %}
                </article>

            </div>
        </div>
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
