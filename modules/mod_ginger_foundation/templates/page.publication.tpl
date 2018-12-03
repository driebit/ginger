{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id extraClasses="masthead--small" %}

    <main id="main-content" role="main">

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% block page_actions %}
                    {% catinclude "page-actions/page-actions.tpl" id %}
                {% endblock %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "blocks/blocks.tpl" id=id %}
            </article>
        </div>

        {% if id.o.haspart %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hassubject=[id,'haspart'] sort="seq" pagelen=100}] as result %}

                    {% include "list/list.tpl" list_id="list--publication" hide_showall_button items=result extraClasses="" class="list--publication" list_template="list/list-item-publication.tpl" id=id %}
                {% endwith %}
            </aside>
        {% endif %}
    </main>

    <button class="btn--expand-all do_expand" data-type="all" data-parent="list__item-publication" data-content="list__item-publication__body"><span>{_ Expand all _}</span><span>{_ Contract all _}</span></button>
{% endblock %}
