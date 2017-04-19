{% extends "base.tpl" %}

{% block body_class %}t--article-sided{% endblock %}

{% block content %}
    <main class="page--sided">

        <article class="main-content--sided">

            {% catinclude "published/published.tpl" id %}

            {% catinclude "category-of/category-of.tpl" id class="category-of--sided" %}

            {% include "page-title/page-title.tpl" id=id %}

            {% include "subtitle/subtitle.tpl" id=id %}

            {% catinclude "page-actions/page-actions.tpl" id %}

            {% include "summary/summary.tpl" id=id %}

            {% with id.media|without_embedded_media:id|first as dep %}
                {% catinclude "media/media.tpl" dep %}
            {% endwith %}

            {% include "body/body.tpl" id=id %}

            {% include "blocks/blocks.tpl" id=id %}

            {% include "copyrights/copyrights.tpl" id=id %}

            {% include "attached-media/attached-media.tpl" id=id %}

        </article>

        <aside class="main-aside--sided">
            {% include "part-of/part-of-aside.tpl" id=id %}

            {% include "about/about.tpl" id=id %}

            {% catinclude "main-aside/main-aside.tpl" id %}

        </aside>
    </main>
{% endblock %}
