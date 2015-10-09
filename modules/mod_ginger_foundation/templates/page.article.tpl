{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}t--article-sided{% endblock %}

{% block content %}
    <main role="main" class="page--sided">

        <article class="main-content--sided">
            {% catinclude "published/published.tpl" id %}

            {% catinclude "category-of/category-of.tpl" id class="category-of--sided" %}

            {% include "page-title/page-title.tpl" id=id %}

            {% include "subtitle/subtitle.tpl" id=id %}

            {% catinclude "page-actions/page-actions.tpl" id %}

            {% include "summary/summary.tpl" id=id %}

            {% include "body/body.tpl" id=id %}

            {% include "blocks/blocks.tpl" id=id %}

            {% include "copyrights/copyrights.tpl" id=id %}

            {% include "attached-media/attached-media.tpl" id=id %}

            {% include "comments/comments.tpl" id=id %}
        </article>

        <aside class="main-aside--sided">
            {% include "part-of/part-of-aside.tpl" id=id %}

            {% if id.o.fixed_context %}
                {% with m.search[{query hassubject=[id,'fixed_context'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Gerelateerd" items=result %}

                    {% include "list/list.tpl" list_id="list--fixed-context" class="list--sided" items=result extraClasses="" id=id %}

                {% endwith %}
            {% elif id.subject %}
                {% with m.search[{match_objects id=id pagelen=6}] as result %}
                    {% include "list/list-header.tpl" id=id list_title=_"Gerelateerd" items=result %}

                    {% include "list/list.tpl" list_id="list--match-objects" items=result class="list--sided" extraClasses="" id=id %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
