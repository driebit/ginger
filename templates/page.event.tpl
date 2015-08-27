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

                            <h1> related test </h1>

                            {% if resource.o.fixed_context %}
                                {% with resource.o.fixed_context as result %}
                                    {% include "list/list.tpl" items=result cols=3 extraClasses="" %}
                                {% endwith %}
                            {% elif resource.subject %}
                                {% with m.search[{match_objects id=id pagelen=5}]|make_list|element:1 as result %}
                                    {% include "list/list.tpl" items=result cols=3 extraClasses="" %}
                                {% endwith %}
                            {% endif %}
                                  
                    </article>

                </div>
            </main>
        {% endwith %}
    </div>
{% endblock %}
