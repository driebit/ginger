{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}location{% endblock %}

{% block content %}
    <div class="page--location page__content-wrapper">
        {% with id as location %}
            {% include "_masthead.tpl" article=location %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ location.title }}</h1>

                    {% include "_about.location.tpl" title="Adres" location=location %}

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
                {% with location.s.located_in as events %}
                    {% if events %}
                        {% if events|length > 10 %}
                            Meer dan tien
                            {% include
                                "_correlated-items.tpl"
                                items=events|slice:[1,10]
                                showMetaData="date"
                                title="Evenementen in "++location.title variant="related"
                                showMoreLabel="Toon alle"
                                showMoreCollection=events
                            %}
                        {% else %}
                            Minder dan tien
                            {% include "_correlated-items.tpl" items=events showMetaData="date" title="Evenementen in "++location.title variant="related" %}
                        {% endif %}
                    {% endif %}
                {% endwith %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
