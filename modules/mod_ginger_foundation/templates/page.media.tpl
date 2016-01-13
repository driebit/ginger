{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        <div class="foldout">

            {% catinclude "category-of/category-of.tpl" id %}

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% catinclude "part-of/part-of.tpl" id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "summary/summary.tpl" id=id %}

                {% catinclude "media/media.tpl" id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}

                {% catinclude "list/list-simple.tpl" id items=id.o.actor header=_"Actors: " %}

                {% include "comments/comments.tpl" id=id %}
            </article>

        </div>

        {% catinclude "main-aside/main-aside.tpl" id %}

    </main>
{% endblock %}
