{% extends "base.tpl" %}

{% block title %}{_ Zoeken naar _} {{ q.qs }}{% endblock %}

{% block body_class %}t--search{% endblock %}

{% block content %}
    <main role="main">

        <div class="foldout do_foldout">
            <form class="search-form--page" role="search" action="{% url search %}" method="get">
                <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
                <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
                <input type="text" class="search-query" name="qs" value="{{q.qs|escape}}" autocomplete="off">
                <button type="submit" class="btn--search" title="{_ Zoeken _}"><i class="icon--search"></i></button>
            </form>
        </div>
        <aside class="main-aside">
            {% with m.search.paged[{query text=q.qs pagelen=10 page=q.page}] as result %}
                {% include "list/list.tpl" class="list--vertical" list_id="list--query" list_template="list/list-item-vertical.tpl" items=result extraClasses="" id=id %}
            {% endwith %}
        </aside>
    </main>
{% endblock %}
