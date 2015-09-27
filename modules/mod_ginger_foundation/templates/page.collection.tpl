{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}{% endblock %}

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

                {% include "comments/comments.tpl" id=id %}
            </article>

        </div>
        {% if id.o.haspart %}
            <aside class="main-aside">
                {% with m.search[{query hassubject=[id,'haspart'] pagelen=6}] as result %}
                    {% include "list/list-header.tpl" id=id list_title=_"Inhoud" items=result %}

                    {% include "list/list.tpl" list_id="list--haspart" items=result extraClasses="" id=id %}
                {% endwith %}
            </aside>
        {% endif %}
    </main>
{% endblock %}
