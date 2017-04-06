{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--beeldenzoeker{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main id="top" data-page-id="{{ id }}">
        <div class="beeldenzoeker-home__header" style="background-image: url({% image_url banner.id width="1600" height="400" crop=banner.crop_center quality="80" %}); background-size: cover;">
            <div class="beeldenzoeker-home__header__title">
                <h1>{{ id.title }}</h1>
                {% if id.subtitle %}
                    <h2>{{ id.subtitle }}</h2>
                {% endif %}
            </div>
        </div>
        <div class="beeldenzoeker-home__page-search">
        	{% include "search-suggestions/search-form.tpl" id=id placeholder=placeholder.title
                formclass="page-search__search"
                wrapperclass="page-search__container"
                buttonclass="btn--search page-search-submit"
                togglebutton="false"
                buttonlabel=_"Search"
                suggestionsclass="page-search__suggestions"
                iconclass="icon--search"
            %}
        </div>

        {% if id.o.haspart %}
            {% for r in id.o.haspart %}
                {% if r.o.haspart %}
                    <div class="beeldenzoeker-home__collections">
                        <h2 class="beeldenzoeker-home__section-title">{{ r.title }}</h2>

                        {% include "list/list.tpl" class="list-carousel" items=r.o.haspart id=id hide_showmore_button list_id="list-"++r.id %}
                    </div>
                {% else %}

                    {% with m.search[{ginger_search query_id=r sort="-rsc.pivot_date_start" pagelen=6 page=q.page}] as result %}
                        <div class="beeldenzoeker-home__collections">
                            <h2 class="beeldenzoeker-home__section-title">{{ r.title }}</h2>

                            {% include "list/list.tpl" items=result id=id hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
                        </div>
                    {% endwith %}
                {% endif %}
            {% endfor %}
        {% endif %}

        {% include "back-to-top/back-to-top-link.tpl" %}

        {% include "beeldenzoeker/home/recent.tpl" %}

    </main>
{% endwith %}
{% endblock %}

{% block footer %}{% endblock %}
