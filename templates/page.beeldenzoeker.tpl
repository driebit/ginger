{% extends "beeldenzoeker/base.tpl" %}

{% block body_class %}t--home{% endblock %}

{% block content %}
{% with id.o.hasbanner[1].depiction|default:id.depiction as banner %}

    <main role="main" data-page-id="{{ id }}">
        <div class="home__header" style="background-image: url({% image_url banner.id width="1600" height="400" crop=banner.crop_center quality="80" %}); background-size: cover;">
            <div class="home__title">
                <h1>{{ id.title }}</h1>
                {% if id.subtitle %}
                    <h2>{{ id.subtitle }}</h2>
                {% endif %}
            </div>
        </div>
        <div class="page-search">
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

        <div class="home-collections">
            <h2 class="home-section__title">{_ A selection from the collection of _} {{ m.site.beeldenzoeker_title }}</h2>

            {# With facets: {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="vrouw" agg=['creator', 'terms', ['field', 'maker.creator.name.keyword']] pagelen="3"}] as result %} #}
            {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="vrouw" pagelen="3"}] as result %}
                {% include "list/list-beeldenzoeker.tpl" class="list-carousel" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </div>

        <div class="home-events">
            <h2 class="home-section__title">Foto's van evenementen van het museum</h2>

            {% with m.search[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen="10"}] as result %}
                {% include "list/list-beeldenzoeker.tpl" class="list-carousel" items=result id=id hide_showall_button hide_showmore_button list_id="list-"++r.id list_template="list/list-item-beeldenzoeker.tpl" %}
            {% endwith %}
        </div>

        <div class="home-latest">
            <div class="main-container">
                <h2 class="home-section__title">Recent toegevoegd</h2>

                {% with m.search.paged[{elastic index=m.config.mod_ginger_adlib_elasticsearch.index.value text="amsterdam" pagelen="20"}] as result %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}

                    {% include "list/list-beeldenzoeker.tpl" items=result id=id hide_showall_button hide_showmore_button list_id="list-infinite" list_template="list/list-item-beeldenzoeker.tpl" %}

                    {% pager result=result dispatch="beeldenzoeker" id=id qargs %}

                    {% lazy action={moreresults result=result
                              target="list-infinite"
                              template="list/list-item-beeldenzoeker.tpl"
                              is_result_render
                              visible}
                    %}
                {% endwith %}
            </div>
        </div>


    </main>
{% endwith %}
{% endblock %}
