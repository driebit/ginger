{% extends "base.tpl" %}

{% block body_class %}t--no-masthead{% endblock %}

{% block content %}
    <main role="main">

        <div class="foldout do_foldout">

            <article class="main-content">
                {% include "page-title/page-title.tpl" id=id title=_"Everything for "++"'"++id.title++"'" %}
            </article>

        </div>
        {% if q.id %}
            <aside class="main-aside">
                {% if q.direction == 'subject' %}
                    {% with m.search.paged[{ginger_search hassubject=[q.id, q.type] cat_exclude=['media'] pagelen=6 page=q.page}] as result %}
                        {% include "list/list.tpl" list_id="list--query" items=result extraClasses="" id=id %}
                    {% endwith %}
                {% else %}
                    {% with m.search.paged[{ginger_search hasobject=[q.id, q.type] cat_exclude=['media'] pagelen=6 page=q.page}] as result %}
                        {% include "list/list.tpl" list_id="list--query" items=result extraClasses="" id=id %}
                    {% endwith %}
                {% endif %}
            </aside>
        {% endif %}
    </main>
{% endblock %}
