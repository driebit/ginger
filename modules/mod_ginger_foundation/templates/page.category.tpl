{% extends "base.tpl" %}

{% block content %}

    <main id="main-content" role="main" class="page--sided">

        <div class="">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% block page_actions %}
                    {% catinclude "page-actions/page-actions.tpl" id %}
                {% endblock %}

                {% include "summary/summary.tpl" id=id %}

            </article>

        </div>

        <aside class="main-aside">
            {% with m.search[{ginger_search cat=id.name pagelen=6 page=q.page}] as result %}
                {% include "list/list.tpl" list_id="list--query" hide_showall_button items=result extraClasses="" id=id %}
            {% endwith %}
        </aside>
    </main>
{% endblock %}
