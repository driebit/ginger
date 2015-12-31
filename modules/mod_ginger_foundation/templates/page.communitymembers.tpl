{% extends "base.tpl" %}

{% block content %}
    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "part-of/part-of.tpl" id=id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}
            </article>

        </div>
        <aside class="main-aside">
            {% with m.search[{query query_id=id pagelen=50 page=q.page}] as result %}
                {% include "list/list.tpl" list_id="list--query" items=result list_template="list/list-item-member.tpl" class="list--community-members" id=id %}
            {% endwith %}
        </aside>
    </main>
{% endblock %}
