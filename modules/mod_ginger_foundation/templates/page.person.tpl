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

    </main>
{% endblock %}
