{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}location{% endblock %}

{% block content %}
    <div class="page--event__content-wrapper">
        {% with id as location %}
            {% include "_masthead.tpl" article=location %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ location.title }}</h1>

                    {% include "_about.location.tpl" title="Adres" location=location.located_in %}

                    {% if location.summary %}
                        <div class="page__content__intro">
                            {{ location.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ location.body|show_media }}
                    </div>
                </article>
            </main>

            {% block correlatedItems %}
                {% with m.search[{query cat_exclude=cat_exclude text="lectoraat" pagelen=12}] as result %}
                    {% if result %}
                        {% include "_correlated-items.tpl" items=result showMetaData="date" title="Evenementen in "++location.title variant="related" %}
                    {% endif %}
                {% endwith %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
