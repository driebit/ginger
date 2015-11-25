{% extends "base.tpl" %}

{% block title %}{{ id.title }}{% endblock %}

{% block body_class %}t--search{% endblock %}

{% block content %}

    <main role="main" class="do_search do_search_ui">

        <div class="search__top">
            <div class="search__top__container">
                <h1 class="page-title--search">{_ Search _}</h1>

                <form class="search__top__form">
                    {% include "search/components/input-text.tpl" %}
                    <button type="submit" class="global-search__submit" title="{_ Search _}">{_ Search _}</button>
                </form>

                <a href="#list" class="btn--result-option is-active"><i class="icon--list"></i>{_ list _}</a>
                <a href="#map" class="btn--result-option"><i class="icon--map-lines"></i>{_ map _}</a>
            </div>
        </div>
        <div class="search__bottom">
            {% block search_filters %}{% endblock %}

            {%  wire
                    name="search-list"
                    action={update target="search-list" text="<p style='margin-top:20px'>Loading...</p>"}
                    action={update
                            target="search-list"
                            template="search/search-query-list.tpl"
                            cg_name="default_content_group" }
                    %}

            {%  wire
                    name="search-map"
                    action={update target="search-map" text="<p style='margin-top:20px'>Loading...</p>"}
                    action={update
                            target="search-map"
                            template="search/search-query-map.tpl"
                            cg_name="default_content_group" }
                    %}


            <div id="search-results" class="search__results">

                <div id="search-list" class="search__results__list search__result__container"></div>
                <div id="search-map" class="search_results__map search__result__container"></div>

            </div>
        </div>
    </main>

{% endblock %}
