{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}t--person{% endblock %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        {% include "person/person-profile.tpl" %}

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">

                {% include "page-title/page-title.tpl" id=id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "person/person-details.tpl" person=id %}

            </article>
        </div>

        {% if id.s.author %}
            <aside class="main-aside">
                {% with m.search[{query hasobject=[id,'author'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Authored" items=result %}

                    {% include "list/list.tpl" list_id="list--authored" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

        {% if id.o.interest %}
            <aside class="main-aside">
                {% with m.search[{query hassubject=[id,'interest'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Favorites" items=result %}

                    {% include "list/list.tpl" list_id="list--favorited" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

    </main>
{% endblock %}
