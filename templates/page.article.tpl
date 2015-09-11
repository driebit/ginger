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
        <aside class="main-aside">
            {% if id.o.fixed_context %}
                {% with m.search[{query hassubject=[id,'fixed_context'] pagelen=6}] as result %}

                    {% if result|length > 0 %}
                        {% include "list/list-header.tpl" id=id list_title=_"Gerelateerd" %}

                        {% include "list/list.tpl" list_id="list--fixed-context" items=result extraClasses="" list_title=_"Gerelateerd" id=id %}

                        {% button class="list__more" text="Toon meer resultaten..." action={moreresults result=result
                            target="list--fixed-context"
                            template="list/list-item.tpl"}
                            %}
                    {% endif %}

                {% endwith %}
            {% elif id.subject %}
                {% with m.search[{match_objects id=id pagelen=6}] as result %}
                    {% if result|length > 0 %}
                        {% include "list/list-header.tpl" id=id list_title=_"Gerelateerd" %}

                        {% include "keywords/keywords.tpl" id=id %}

                        {% include "list/list.tpl" list_id="list--match-objects" items=result extraClasses="" list_title=_"Gerelateerd" id=id %}

                        {% button class="list__more" text=_"Toon meer resultaten..." action={moreresults result=result
                            target="list--match-objects"
                            template="list/list-item.tpl"}
                            %}
                    {% endif %}
                {% endwith %}
            {% endif %}
        </aside>
    </main>
{% endblock %}
