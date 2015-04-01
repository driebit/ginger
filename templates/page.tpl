{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}article{% endblock %}

{% block content %}
    <div class="page--article page__content-wrapper">
        {% with id as article %}
            {% include "_masthead.tpl" article=article %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ article.title }}</h1>

                    <div class="page__content__organiser"></div>

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
