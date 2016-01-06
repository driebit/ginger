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

        {% catinclude "main-aside/main-aside.tpl" id %}

    </main>
{% endblock %}
