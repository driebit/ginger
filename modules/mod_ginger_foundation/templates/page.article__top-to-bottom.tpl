{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        <div class="foldout do_foldout">

            {% catinclude "category-of/category-of.tpl" id %}

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% include "part-of/part-of.tpl" id=id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}

                {% include "copyrights/copyrights.tpl" id=id %}

                {% include "attached-media/attached-media.tpl" id=id %}

                {% include "comments/comments.tpl" id=id %}
            </article>

        </div>

        {% catinclude "main-aside/main-aside.tpl" id %}

    </main>
{% endblock %}
