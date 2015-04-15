{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}generic{% endblock %}

{% block content %}
    <div class="page--generic page__content-wrapper">
        {% with id as article %}
            {% block masthead %}
                {% include "_masthead.tpl" article=article %}
            {% endblock %}

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

                    {% block comments %}
                        {% if article.s.comment %}
                            {% include "_comments.tpl" comments=article.s.comment %}
                        {% endif %}
                    {% endblock %}
                </article>
            </main>

            {% block correlatedItems %}{% endblock %}
        {% endwith %}
    </div>
{% endblock %}
