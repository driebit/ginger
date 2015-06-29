{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}generic{% endblock %}

{% block content %}
    <div class="page--generic page__content-wrapper do_ginger_default_content_group_navigation">

        {% with id as article %}
            {% block masthead %}
                {% include "_masthead.tpl" article=article %}
            {% endblock %}

            <main role="main" class="page__main-content">

                <article class="page__content do_ginger_default_article_foldout">

                    <a href="#" class="btn-article-foldout" alt="{_ Lees meer _}" title="{_ Lees meer _}"></a>

                    <h1 class="page__content__title">{{ article.title }}</h1>

                    {% if article.summary %}
                        <div class="page__content__intro">
                            {{ article.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ article.body|show_media }}
                    </div>

                    {% block page_blocks %}
                        {% include "_blocks.tpl" %}
                    {% endblock %}

                    {% block comments %}
                        {% if article.s.comment %}
                            {% include "_comments.tpl" comments=article.s.comment %}
                        {% endif %}
                    {% endblock %}
                </article>
            </main>

            {% block correlatedItems %}
                {% if article.o.fixed_context %}
                    {% with article.o.fixed_context as result %}
                        {% include "_correlated-items.tpl" items=result showMetaData="date" title="Gerelateerd" variant="related" %}
                    {% endwith %}
                {% elif article.subject %}
                    {% with m.search[{match_objects id=article pagelen=5}] as result %}
                        {% if result %}
                            {% include "_correlated-items.tpl" items=result showMetaData="date" title="Gerelateerd" variant="related" useRank=1 %}
                        {% endif %}
                    {% endwith %}
                {% endif %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
