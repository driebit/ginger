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

                    <button type="button" class="btn-article-foldout" alt="{_ Lees meer _}" title="{_ Lees meer _}"></button>

                    <h1 class="page__content__title">{{ event.title }}</h1>

                    {% block organizer %}
                        {% with event.organised_by as organiser %}
                            {% if m.comment.rsc[id]|length > 0 %}
                                {%
                                    include "_metadata.tpl" person=organiser role="Organisator"
                                        links=[
                                            [m.comment.rsc[id]|length ++ " reacties", "#comments", "anchor"],
                                            ['Aanmelden'                            , '#signup', 'primary']
                                        ]
                                %}
                            {% else %}
                                {%
                                    include "_metadata.tpl" person=organiser role="Organisator"
                                        links=[
                                            ["reacties",  "#comments", "anchor"],
                                            ['Aanmelden', '#signup', 'primary']
                                        ]
                                %}
                            {% endif %}
                        {% endwith %}
                    {% endblock %}

                    {% block venue %}
                        {% with event.located_in as location %}
                            {% include "_about_location.tpl" title="Locatie" location=event.located_in %}
                        {% endwith %}
                    {% endblock %}

                    {% block attendees %}
                        {% with event.s.participant as participants %}
                            {% include "_about_people.tpl" title="Deelnemers" people=participants %}
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
