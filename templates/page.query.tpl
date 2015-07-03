{% extends "page.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}query{% endblock %}

{% block content %}
    <div class="page--query page__content-wrapper">
        <div class="query-results">
            <h1 class="query-results__title">{{ id.title}}</h1>

            {% block queryResults %}
                {% with m.search.paged[{query query_id=id pagelen=24 page=q.page}] as result %}
                    {% if result %}
                        {% pager id=id result=result hide_single_page=1 gingerpager=true %}

                        {% include "_correlated-items.tpl" items=result title="" %}
                    {% else %}
                        <p class="query-results__no-results">{_ Geen resultaten _}</p>
                    {% endif %}
                {% endwith %}
            {% endblock %}
        </div>
    </div>
{% endblock %}
