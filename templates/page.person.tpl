{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}person{% endblock %}

{% block content %}
    <div class="page--person__content-wrapper">
        {% with id as person %}
            {% include "_masthead.tpl" article=person %}

            <main role="main" class="page__main-content">
                {% if person.depiction %}
                    <img class="page__avatar" src="{% image_url person.depiction mediaclass='img-avatar' %}" alt=""/>
                {% endif %}

                <article class="page__content">
                    <h1 class="page__content__title">{{ person.title }}</h1>

                    {% if person.summary %}
                        <div class="page__content__intro">
                            {{ person.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ person.body|show_media }}
                    </div>
                </article>
            </main>

            {% with m.search[{query cat_exclude=cat_exclude text="lectoraat" pagelen=12}] as result %}
				{% if result %}
                    {% include "_correlated-items.tpl" items=result showMetaData="date" title="Bijdragen van "++person.title variant="related" %}
                {% endif %}
            {% endwith %}
        {% endwith %}
    </div>
{% endblock %}
