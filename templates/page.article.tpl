{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}{% endblock %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "part-of/part-of.tpl" id=id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}

                {% include "comments/comments.tpl" id=id %}

                <h1>load more test</h1>

                {% with m.search[{query hassubject=[338,'fixed_context'] pagelen=2}] as result %}
                      {% include "list/list.tpl" cols=3 items=result list_id="testlist" %}
                      {% button class="list__more" text="LOAD MORE..." action={moreresults result=result
                        target="testlist"
                        template="list/list-item.tpl"}
                        %}
                {% endwith %}

               <!--  {% include "blocks/blocks.tpl" %}

                    <style>
                        .carousel li {
                            display: inline-block;
                            width: 30px;
                        }
                    </style>

                    <h1>carousel</h1>

                    {% include "carousel/carousel.tpl"
                        items=m.rsc.gallerytest.o.haspart
                        itemtemplate="carousel/carousel-item.tpl"
                        pagertemplate="carousel/carousel-pager-item.tpl"
                        extraClasses=""
                        carousel_id="testcarousel"
                        config="{
                          infinite: true,
                          slidesToShow: 3,
                          slidesToScroll: 1,
                          arrows: false
                        }"
                    %} -->
            </article>
        </div>
        <aside class="main-aside">
            <div class="list-header">
                <h2 class="list-header__title">{_ Gerelateerd _}</h2>
            </div>
            {% if id.o.fixed_context %}
                {% with id.o.fixed_context as result %}
                    {% include "list/list.tpl" items=result extraClasses="" %}
                {% endwith %}
            {% elif id.subject %}
                {% with m.search[{match_objects id=id pagelen=5}]|make_list|element:1 as result %}
                    {% include "list/list.tpl" items=result extraClasses="" %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
