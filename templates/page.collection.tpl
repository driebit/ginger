{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}collection{% endblock %}

{% block content %}
    <div class="page--event__content-wrapper">
        {% with id as collection %}
            {% include "_masthead.tpl" article=collection %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ collection.title }}</h1>

                    {% if collection.summary %}
                        <div class="page__content__intro">
                            {{ collection.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ collection.body|show_media }}
                    </div>
                </article>
            </main>

            {% if id.o.haspart %}
                {% include "_correlated-items.tpl" items=id.o.haspart showMetaData="date" title="" %}
            {% endif %}

        {% endwith %}
    </div>
{% endblock %}
