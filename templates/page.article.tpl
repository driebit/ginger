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
                <article class="page__content">
                    <h1 class="page__content__title">{{ article.title }}</h1>

                    {% block metadata %}
                        {%
                            include "_metadata.tpl" role="Auteur" person=article.author
                                links=[
                                    ["X reacties", "#comments", "anchor"],
                                    ["Delen"     , "#share"   , "secondary"]
                                ]
                            %}
                    {% endblock %}

                    {% if article.summary %}
                        <div class="page__content__intro">
                            {{ article.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ article.body|show_media }}
                    </div>
                </article>
            </main>

            {% block correlatedItems %}{% endblock %}
        {% endwith %}
    </div>
{% endblock %}
