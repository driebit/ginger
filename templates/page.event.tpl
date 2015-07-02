{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}event{% endblock %}

{% block content %}
    <div class="page--event page__content-wrapper">
        {% with id as event %}
            {% block masthead %}
                {% include "_masthead.tpl" article=event %}
            {% endblock %}

            <main role="main" class="page__main-content">
                <article class="page__content do_ginger_default_article_foldout">

                    <a href="#" class="btn-article-foldout" alt="{_ Lees meer _}" title="{_ Lees meer _}"></a>

                    <h1 class="page__content__title">{{ event.title }}</h1>

                    {% block organizer %}
                        {% with event.organized_by as organizer %}
                            {%
                                include "_metadata.tpl" person=organizer role="Organisator"
                                    links=[['Aanmelden', '#signup', 'primary']]
                            %}
                        {% endwith %}
                    {% endblock %}

                    {% block venue %}
                        {% with event.located_in as location %}
                            {% include "_about.location.tpl" title="Locatie" location=event.located_in %}
                        {% endwith %}
                    {% endblock %}

                    {% block attendees %}
                        {% with event.s.participant as participants %}
                            {% include "_about.people.tpl" title="Deelnemers" people=participants %}
                        {% endwith %}
                    {% endblock %}

                    {% if event.summary %}
                        <div class="page__content__intro">
                            {{ event.summary }}
                        </div>
                    {% endif %}

                    <div class="page__content__body">
                        {{ event.body|show_media }}
                    </div>

                    {% block comments %}
                        {% with m.comment.rsc[id] as comments %}
                            {% include "_comments.tpl" comments=comments %}
                        {% endwith %}
                    {% endblock %}
                </article>
            </main>

            {% block correlatedItems %}
                {% with m.search[{query cat="event" id_exclude=event.id}] as result %}
                    {% if result %}
                        {% if result|length > 10 %}
                            {% include "_correlated-items.tpl"
                                items=result|slice:[1,10]
                                showMetaData="date"
                                title="Andere evenementen"
                                variant="related"
                                showMoreLabel="Toon alle"
                                showMoreQueryRsc=m.rsc.le_all_events
                            %}
                        {% else %}
                            {% include "_correlated-items.tpl" items=result showMetaData="date" title="Andere evenementen" variant="related" %}
                        {% endif %}
                    {% endif %}
                {% endwith %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
