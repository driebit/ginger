{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}article{% endblock %}

{% block content %}
    <div class="page--article page__content-wrapper">
        {% with id as article %}
            {% block masthead %}
                {% include "_masthead.tpl" article=article %}
            {% endblock %}

            <main role="main" class="page__main-content">
                <article class="page__content do_ginger_default_article_foldout">

                    <button type="button" class="btn-article-foldout" alt="{_ Lees meer _}" title="{_ Lees meer _}"></button>

                    <h1 class="page__content__title">{{ article.title }}</h1>

                    {% block metadata %}
                        {% if m.comment.rsc[id]|length > 0 %}
                            {%
                                include "_metadata.tpl" role="Auteur" person=article.author
                                    links=[
                                        [m.comment.rsc[id]|length ++ " reacties", "#comments", "anchor"],
                                        ["Delen"                                , "#share"   , "secondary"]
                                    ]
                                %}
                        {% else %}
                            {%
                                include "_metadata.tpl" role="Auteur" person=article.author
                                    links=[
                                        ["reacties", "#comments", "anchor"],
                                        ["Delen"   , "#share"   , "secondary"]
                                    ]
                                %}
                        {% endif %}
                    {% endblock %}

                    {% if article.summary %}
                        <div class="page__content__intro">
                            {{ article.summary }}
                        </div>
                    {% endif %}

                    {# Fix article with just media #}
                    {% catinclude "_depiction_media.tpl" id %}

                    <div class="page__content__body">
                        {{ article.body|show_media }}
                    </div>

                    {% block page_blocks %}
                        {% include "_blocks.tpl" %}
                    {% endblock %}

                    {% with m.comment.rsc[id] as comments %}
                        {% include "_comments.tpl" comments=comments %}
                    {% endwith %}

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
