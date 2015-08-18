{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}page{% endblock %}

{% block content %}
    <div class="do_content_group_nav">
        
        {% with id as article %}

            {% block masthead %}
                {% include "masthead/masthead.tpl" article=article %}
            {% endblock %}

            <main role="main" class="">

                <article class="do_article_foldout">

                    {% block foldout %}
                        {% include "foldout/foldout.tpl" %}
                    {% endblock %}

                    {% block page_actions %}
                        {% include "page-actions/page-actions.tpl" id=id %}
                    {% endblock %}

                    {% block page_title %}
                        <h1 class="">{{ article.title }}</h1>
                    {% endblock %}

                    {% block summary %}
                        {% if article.summary %}
                            <div class="">
                                {{ article.summary }}
                            </div>
                        {% endif %}
                    {% endblock %}

                    {% block depiction %}
                        {% catinclude "depiction/depiction.tpl" id %}
                    {% endblock %}

                    {% block body %}
                        <div class="">
                            {{ article.body|show_media }}
                        </div>
                    {% endblock %}

                    {% block page_blocks %}
                        {% include "blocks/blocks.tpl" %}
                    {% endblock %}

                    {% block comments %}
                        {% if article.s.comment %}
                            {% include "comments/comments.tpl" comments=article.s.comment %}
                        {% endif %}
                    {% endblock %}

                </article>
            </main>

        {% endwith %}

    </div>
{% endblock %}
