{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}article{% endblock %}

{% block content %}
    <div class="page--event__content-wrapper">
        {% with id as article %}
            {% include "_masthead.tpl" article=article %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ article.title }}</h1>

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

            {% if id.o.haspart %}
                {% include "_correlated-items.tpl" items=id.o.haspart showMetaData="date" title="" %}
            {% endif %}

        {% endwith %}
    </div>
{% endblock %}
