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

            {% with id.media|without_embedded_media:id|first as dep %}
                {% include "media/media.image.tpl"  id=dep %}
            {% endwith %}

            {% include "body/body.tpl" id=id %}

            {% include "blocks/blocks.tpl" id=id %}

            {% include "copyrights/copyrights.tpl" id=id %}

            {% include "attached-media/attached-media.tpl" id=id %}

            {% include "comments/comments.tpl" id=id %}

        </article>

        <aside class="main-aside--sided">
            {% include "part-of/part-of-aside.tpl" id=id %}

            {% include "about/about.tpl" id=id %}

            {% if id.o.fixed_context %}
                {% with m.search[{query hassubject=[id,'fixed_context'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Related" items=result %}

                    {% include "list/list.tpl" list_id="list--fixed-context" class="list--sided" items=result extraClasses="" id=id hide_showmore_button hide_showall_button %}

                {% endwith %}
            {% elif id.subject %}
                {% with m.search[{query match_objects=id is_published custompivot="ginger_search" filter=["is_unfindable", "false"] pagelen=6}] as result %}

                    {% include "keywords/keywords-aside.tpl" id=id items=result %}

                    {% include "list/list.tpl" list_id="list--match-objects" items=result class="list--sided" extraClasses="" hide_showmore_button hide_showall_button id=id %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
