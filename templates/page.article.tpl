{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}{% endblock %}

{% block content %}

    <div class="">
        
        {% with m.rsc[id] as resource %}

            {% include "masthead/masthead.tpl" id=id %}

            <main role="main" class="">

                <div class="foldout do_foldout">

                    {% include "foldout/foldout-button.tpl" %}

                    <article class="">

                        {% include "page-actions/page-actions.tpl" id=id %}

                            <h1 class="">{{ resource.title }}</h1>

                            <h1>aantal reacties test</h1>

                            {% include "comments-button/comments-button.tpl" id=id %}

                            {% if resource.summary %}
                                <div class="">{{ resource.summary }}</div>
                            {% endif %}

                            <h1>first depiction</h1>
                            {% with id.depiction.id as first_dep %}
                                {% catinclude "media/media.tpl" first_dep %}
                            {% endwith %}

                            <div class="">{{ resource.body|show_media }}</div>

                            {% include "blocks/blocks.tpl" %}

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
                                %}

                                <h1> related test </h1>

                                {% if resource.o.fixed_context %}
                                    {% with resource.o.fixed_context as result %}
                                        {% include "list/list.tpl" items=result cols=3 extraClasses="" %}
                                    {% endwith %}
                                {% elif resource.subject %}
                                    {% with m.search[{match_objects id=id pagelen=5}]|make_list|element:1 as result %}
                                        {% include "list/list.tpl" items=result cols=3 extraClasses="" %}
                                    {% endwith %}
                                {% endif %}

                                <h1>comments</h1>

                                {% include "comments/comments.tpl" id=id %}

                                <h1>load more test</h1>

                                {% with m.search[{query hassubject=[338,'fixed_context'] pagelen=2}] as result %}
                                      {% include "list/list.tpl" cols=3 items=result list_id="testlist" %}
                                      {% button class="list__more" text="LOAD MORE..." action={moreresults result=result
                                        target="testlist"
                                        template="list/list-item.tpl"}
                                        %}
                                {% endwith %}
                                  
                    </article>

                </div>
            </main>
        {% endwith %}
    </div>
{% endblock %}
