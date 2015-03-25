{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}event{% endblock %}

{% block content %}
    <div class="page--event__content-wrapper">
        {% with id as event %}
            {% include "_masthead.tpl" article=event %}

            <main role="main" class="page__main-content">
                <article class="page__content">
                    <h1 class="page__content__title">{{ event.title }}</h1>

                    {% with event.organized_by as organizer %}
                        {% if organizer %}
                            <div class="page__content__organizer">
                                {% if organizer.depiction %}
                                    <img class="page__content__organizer__depiction" src="{% image_url organizer.depiction mediaclass='img-avatar' %}" alt=""/>
                                {% endif %}

                                <p class="page__content__organizer__name">
                                    Organisator:<br/>
                                    {{ organizer.title }}
                                </p>

                                <a href="" class="ginger-btn-pill--primary page__content__organizer__signup">Aanmelden</a>
                            </div>
                        {% endif %}
                    {% endwith %}

                    {% with event.located_in as location %}
                        {% include "_about.location.tpl" title="Locatie" location=event.located_in %}
                    {% endwith %}

                    {% with event.s.participates_in as participants %}
                        {% include "_about.people.tpl" title="Deelnemers" people=participants %}
                    {% endwith %}

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

            {% block correlatedItems %}
                {% with m.search[{query cat_exclude=cat_exclude text="lectoraat" pagelen=12}] as result %}
                    {% if result %}
                        {% include "_correlated-items.tpl" items=result showMetaData="date" title="Andere evenementen" variant="related" %}
                    {% endif %}
                {% endwith %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
