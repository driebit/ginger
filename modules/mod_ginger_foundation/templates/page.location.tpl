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

                {% catinclude "page-actions/page-actions.tpl" id %}

                <div class="main-content__meta">
                    {% include "meta/meta-location.tpl" id=id %}
                </div>

                {% include "summary/summary.tpl" id=id %}

                {% include "body/body.tpl" id=id %}

            </article>
        </div>

    </main>
{% endblock %}
