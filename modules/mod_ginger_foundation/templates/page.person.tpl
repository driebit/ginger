{% extends "base.tpl" %}

{% block content %}

    {% include "masthead/masthead.tpl" id=id %}

    <main id="main-content" role="main">

        {% include "person/person-profile.tpl" id=id %}

        <div class="foldout do_foldout">

            {% include "foldout/foldout-button.tpl" %}

            <article class="main-content">

                {% catinclude "page-title/page-title.tpl" id %}

                {% include "subtitle/subtitle.tpl" id=id %}

                {% block page_actions %}
                    {% catinclude "page-actions/page-actions.tpl" id %}
                {% endblock %}

                {% include "person/person-details.tpl" person=id %}

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

                {% block attached_media %}
                    {% include "attached-media/attached-media.tpl" id=id %}
                {% endblock %}

            </article>
        </div>

        {% catinclude "main-aside/main-aside.tpl" id %}

    </main>
{% endblock %}
