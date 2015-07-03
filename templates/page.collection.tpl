{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}collection{% endblock %}

{% block content %}
    <div class="page--collection page__content-wrapper do_ginger_default_content_group_navigation">
        {% with id as collection %}
            {% block masthead %}
                {% include "_masthead.tpl" article=collection %}
            {% endblock %}

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

            {% block correlatedItems %}
                {% if id.o.haspart %}
                    {% if id.o.haspart|length > 10 %}
                        {% include "_correlated-items.tpl"
                            items=id.o.haspart|slice:[1,10]
                            showMetaData="date"
                            title="Andere objecten"
                            variant="related"
                            showMoreLabel="Toon alle"
                            showMoreQueryRsc=m.rsc.le_all_events
                        %}
                    {% else %}
                        {% include "_correlated-items.tpl" items=id.o.haspart showMetaData="date" title="Andere objecten" %}
                    {% endif %}
                {% endif %}
            {% endblock %}

        {% endwith %}
    </div>
{% endblock %}
