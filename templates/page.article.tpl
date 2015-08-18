{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}page{% endblock %}

{% block content %}

    <div class="">
        
        {% with id as article %}

            {% include "masthead/masthead.tpl" article=article %}

            <main role="main" class="">

                <div class="foldout">

                    <article class="do_article_foldout">

                        {% include "foldout/foldout.tpl" %}
                        {% include "page-actions/page-actions.tpl" id=id %}

                            <h1 class="">{{ article.title }}</h1>

                            {% if article.summary %}
                                <div class="">{{ article.summary }}</div>
                            {% endif %}
                                             
                            {#% catinclude "depiction/depiction.tpl" id %#}
                         
                            <div class="">{{ article.body|show_media }}</div>

                            {% include "blocks/blocks.tpl" %}

                                <h1>test normal depiction</h1>
                                
                                {% include "depiction/depiction.tpl" id=342 context="content" %}
                                
                                <h1>test list depiction</h1>

                                <ul style="width: 100%">
                                    {% for rsc in m.rsc.listtest.o.haspart %}
                                        <li style="width: 30%; display: inline-block">
                                            {% include "depiction/depiction.tpl" context="related" id=rsc %}
                                        </li>
                                    {% endfor %}
                                </ul>

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
                                    extraClasses=""
                                    config="{
                                      infinite: true,
                                      slidesToShow: 3,
                                      slidesToScroll: 3
                                    }"
                                    carousel_id="testcarousel"
                                %}

                            
                        
                            {% if article.s.comment %}
                                {% include "comments/comments.tpl" comments=article.s.comment %}
                            {% endif %}
                        
                    </article>

                </div>
            </main>
        {% endwith %}
    </div>
{% endblock %}
