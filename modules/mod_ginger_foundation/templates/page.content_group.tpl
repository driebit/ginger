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
            </article>
        </div>
        <aside class="main-aside">
            <div class="list-header">
                <h2 class="list-header__title">{_ Inhoud _}</h2>
            </div>
            {% if content_group.o.hassubnav|length > 1 %}
                {% with m.search[{query hassubject=[id,'hassubnav'] pagelen=6}] as result %}
                    {% include "list/list.tpl" list_id="list--haspart" hide_showall_button items=result extraClasses="" id=id %}
                {% endwith %}
            {% else %}
                {% with content_group.o.hassubnav.id as subnavid %}
                    {% with m.search[{query hassubject=[subnavid,'haspart'] pagelen=6}] as result %}
                        {% include "list/list.tpl" list_id="list--haspart" hide_showall_button items=result extraClasses="" id=id %}
                    {% endwith %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
