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

        {% include "page-nav/page-nav.tpl" %}

        {% with m.search[{query hasobject=[id,'subject'] sort="seq" pagelen=6}] as result %}
        {% if result %}
            <aside class="main-aside">

                    {% include "list/list-header.tpl" id=id list_title=_"Inhoud" items=result %}

                    {% include "list/list.tpl" list_id="list--haspart" hide_showall_button items=result extraClasses="" id=id %}
            </aside>
        {% endif %}
        {% endwith %}
    </main>
{% endblock %}
