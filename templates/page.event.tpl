{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}{% endblock %}

{% block content %}

    <div class="">
        
        {% with m.rsc[id] as resource %}

            {% include "masthead/masthead.tpl" id=id %}

            <main role="main" class="">

                <div class="foldout do_foldout">

                    {% include "foldout/foldout-button.tpl" %}

                    <article class="">

                        {% include "page-actions/page-actions.tpl" id=id %}

                            <h1 class="">{{ resource.title }}</h1>

                            {% if resource.summary %}
                                <div class="">{{ resource.summary }}</div>
                            {% endif %}

                            <div class="">{{ resource.body|show_media }}</div>

                            {% include "blocks/blocks.tpl" %}


                            <h1>deelnemers</h1>
                           
                            <div style="border: 2px solid blue" id="participants">
                                {% include "event/event-participants.tpl" limit=1 id=id %}
                            </div>
                            <a href="#" id="all-participants">alle deelnemers</a>
                            {% wire id="all-participants" type="click" action={update target="participants" template="event/event-participants.tpl" id=id} %}

                                  
                    </article>

                </div>
            </main>
        {% endwith %}
    </div>
{% endblock %}
