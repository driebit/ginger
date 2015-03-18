{% extends "base.tpl" %}

{% block title %}Home{% endblock %}

{% block body_class %}home{% endblock %}

{% block content %}
    <div class="page--event__content-wrapper">
        {% with id as event %}
            {% include "_masthead.tpl" article=event %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ event.title }}</h1>
                    {% if event.summary %}
                        <div class="page__content__intro">
                            {{ event.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ event.body|show_media }}
                    </div>

                </article>
            </main>

            {#
            {% with m.search.paged[{query query_id=m.rsc.agenda.id pagelen=10 page=q.page}] as agenda %}
                {% if agenda %}
                    {% include "_correlated-items.tpl" items=agenda showMetaData="date" title="Aankomende Evenementen" %}
                {% endif %}
            {% endwith %}
            #}

        {% endwith %}
    </div>
{% endblock %}
