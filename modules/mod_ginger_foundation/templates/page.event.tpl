{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main id="main-content" role="main">

        <div class="foldout do_foldout">

            {% block category_of %}
                {% catinclude "category-of/category-of.tpl" id %}
            {% endblock %}

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% include "part-of/part-of.tpl" id=id %}

                {% block page_actions %}
                    {% catinclude "page-actions/page-actions.tpl" id %}
                {% endblock %}

                <div class="main-content--event__meta">
                    {% include "meta/meta-location.tpl" id=id %}
                    {% include "meta/meta-participants.tpl" id=id %}
                </div>

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}

                {% block attached_media %}
                    {% include "attached-media/attached-media.tpl" id=id %}
                {% endblock %}

                {% include "comments/comments.tpl" id=id %}
            </article>

        </div>

        {% catinclude "main-aside/main-aside.tpl" id %}

    </main>
{% endblock %}
