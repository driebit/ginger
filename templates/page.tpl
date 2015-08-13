{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}page{% endblock %}

{% block content %}
    <div class="do_content_group_nav">
        
        {% with id as article %}

            {#% block masthead %#}
                {#% include "_masthead.tpl" article=article %#}
            {#% endblock %#}

            <main role="main" class="">

                <article class="do_article_foldout">

                    <button type="button" class="btn-article-foldout" alt="{_ Lees meer _}" title="{_ Lees meer _}"></button>

                    {% block page_actions %}

                    {% endblock %}

                    {% block title %}
                        <h1 class="">{{ article.title }}</h1>
                    {% endblock %}

                    {% if article.summary %}
                        <div class="">
                            {{ article.summary }}
                        </div>
                    {% endif %}

                    {% block page_depiction %}
                        {% catinclude "depiction/depiction.tpl" id %}
                    {% endblock %}

                    <div class="">
                        {{ article.body|show_media }}
                    </div>

                    {#% block page_blocks %#}
                        {% include "_blocks.tpl" %}
                    {#% endblock %#}

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
