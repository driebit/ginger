{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main role="main">

        {% include "person/person-profile.tpl" id=id %}

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">

                {% catinclude "page-title/page-title.tpl" id %}

                {% catinclude "page-actions/page-actions.tpl" id %}

                {% include "person/person-details.tpl" person=id %}
                
                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% include "attached-media/attached-media.tpl" id=id %}

            </article>
        </div>

        {% if id.s.author %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hasobject=[id,'author'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Authored" items=result %}

                    {% include "list/list.tpl" list_id="list--authored" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

        {% if id.o.interest %}
            <aside class="main-aside">
                {% with m.search[{ginger_search hassubject=[id,'interest'] pagelen=6}] as result %}

                    {% include "list/list-header.tpl" id=id list_title=_"Favorites" items=result %}

                    {% include "list/list.tpl" list_id="list--favorited" items=result extraClasses="" id=id %}

                {% endwith %}
            </aside>
        {% endif %}

    </main>
{% endblock %}
