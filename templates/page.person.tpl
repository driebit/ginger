{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}person{% endblock %}

{% block content %}
    <div class="page--person page__content-wrapper">
        {% with id as person %}
            {% block masthead %}
                {% include "_masthead.tpl" %}
            {% endblock %}

            <main role="main" class="page__main-content">
                {% block avatar %}
                    {% if person.depiction %}
                        <img class="page__avatar" src="{% image_url person.depiction mediaclass='img-avatar' %}" alt=""/>
                    {% elseif person.media|length > 0 %}
                        <img class="page__avatar" src="{% image_url person.media|first mediaclass='img-avatar' %}" alt=""/>
                    {% elseif person.header %}
                        <img class="page__avatar" src="{% image_url person.header.id mediaclass='img-avatar' %}" alt=""/>
                    {% endif %}
                {% endblock %}

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

                    <ul class="page__content__person-details">
                        {% if person.email %}
                            <li class="page__content__person-detail--email">
                                <span class="page__content__person-detail__label">E-mail</span>
                                <a class="page__content__person-detail__value" href="mailto:{{ person.email }}">{{ person.email }}</a>
                            </li>
                        {% endif %}

                        {% if person.website %}
                            <li class="page__content__person-detail--website">
                                <span class="page__content__person-detail__label">Website</span>
                                <a class="page__content__person-detail__value" href="{{ person.website }}">{{ person.website }}</a>
                            </li>
                        {% endif %}

                        {% if person.phone %}
                            <li class="page__content__person-detail--phone">
                                <span class="page__content__person-detail__label">Telefoon</span>
                                <a class="page__content__person-detail__value" href="tel:{{ person.phone }}">{{ person.phone }}</a>
                            </li>
                        {% endif %}

                        {% if person.phone_mobile %}
                            <li class="page__content__person-detail--mobile">
                                <span class="page__content__person-detail__label">Mobiel</span>
                                <a class="page__content__person-detail__value" href="tel:{{ person.phone_mobile }}">{{ person.phone_mobile }}</a>
                            </li>
                        {% endif %}
                    </ul>
                </article>
            </main>

            {% block correlatedItems %}
                {% with m.search[{query hasobject=[person.id,'author'] cat="text"}] as result %}
    				{% if result %}
                        {% include "_correlated-items.tpl" items=result showMetaData="date" title="Bijdragen van "++person.title variant="related" %}
                    {% endif %}
                {% endwith %}
            {% endblock %}
        {% endwith %}
    </div>
{% endblock %}
