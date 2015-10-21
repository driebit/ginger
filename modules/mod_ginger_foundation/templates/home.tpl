{% extends "base.tpl" %}

{% block title %}{{ m.rsc.home.title }}{% endblock %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with m.rsc.home.id as id %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main role="main" page-id="{{ id|pprint }}">
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

                        {% with r.id, "seq", 3 as query_id, sort, pagelen %}                       
                        {% with m.search[{query query_id=query_id sort=sort pagelen=pagelen }] as result %}

                            {% include "list/list-header.tpl" id=id list_title=r.title items=result %}
                            {% include "list/list.tpl" items=result id=id hide_button="1" list_id="list-"++r.id query_id=query_id sort=sort %}

                        {% endwith %}
                        {% endwith %}

                    {% else %}

                        {% with r, '-rsc.pivot_date_start', 10, q.page as query_id, sort, pagelen, page %} 
                        {% with m.search[{query query_id=query_id sort=sort pagelen=10 page=page }] as result %}

                            {% include "list/list-header.tpl" id=id list_title=r.title items=result %}
                            {% include "list/list.tpl" items=result id=id hide_button="1" list_id="list-"++r.id query_id=query_id sort=sort page=page %}

                        {% endwith %}
                        {% endwith %}

                    {% endif %}
                {% endfor %}
            {% endif %}
    </main>
{% endwith %}
{% endwith %}
{% endblock %}
