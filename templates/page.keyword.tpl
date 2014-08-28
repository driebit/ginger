{% extends "page.tpl" %}

{% block page_class %}t-collection t-grid{% endblock %}

{% block content %}
    <main class="collection">

        {% block body %}
            <h2 class="page-title">{{ m.rsc[id].title }}</h2>
            <ul class="grid">
            {% with m.search.paged[{referrers id=id pagelen=9 page=q.page}] as result %}
                {% for list_id, pred_id in result %}
                    {% catinclude "_grid_item.tpl" list_id counter=forloop.counter %}
                {% endfor %}
            {% endwith %}
            </ul>
        {% endblock %}

    </main>
{% endblock %}
