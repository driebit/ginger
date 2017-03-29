{% extends "beeldenzoeker/base.tpl" %}

{# {% block title %}{_ Search _}{% endblock %} #}

{% block body_class %}t--search{% endblock %}

{% block content %}

    <main role="main" class="do_search do_search_ui">

    	<form class="bz-search page-search" role="search">
		    <div class="page-search__container">
		        <input type="text"
		            class="input-search do_search_cmp_input_text"
		            name="qs"
		            value=""
		            placeholder="{_ Search _}"
		          />
		          <button type="submit" class="global-search__submit page-search-submit" title="{_ Search _}">{_ Search _}</button>
		          <div class="do_search_cmp_types">
                    <a href="#list" class="btn--result-option is-active"><i class="icon--list"></i>{_ list _}</a>
                    {# <a href="#map" class="btn--result-option"><i class="icon--map-lines"></i>{_ map _}</a> #}
                    {# {% all include "search/search-buttons.tpl" %} #}
                </div>
		    </div>
		</form>

        {% block search_intro %}{% endblock %}

        <div class="bz-search__container">
            {% include "beeldenzoeker/search/search-filters.tpl" %}

            {%  wire
                    name="search-list"
                    action={update
                            target="search-list"
                            template="beeldenzoeker/search-query-wrapper.tpl"
                            show_pager
                            cg_name="default_content_group" }
                    %}

            <div id="search-results" class="search__results">
                {% block search_sorting %}{% endblock %}

                <div id="search-list" class="search__results__list search__result__container"></div>

            </div>
        </div>
    </main>

{% endblock %}
