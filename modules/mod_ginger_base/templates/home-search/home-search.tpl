<form class="home__search" role="search" action="{% url search %}" method="get">
    <div class="main-container">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="text"
            class="do_home_search"
            name="qs"
            value="{{q.qs|escape}}"
            placeholder="{{ placeholder_text }}"
            autocomplete="off"
            data-param-wire="show-home-suggestions"
            data-param-results="home__search__suggestions-{{ #identifier }}"
            data-param-container="home__search-{{ #identifier }}"  />

        <button type="submit" class="btn--search home__search-submit" title="{_ Search _}"><i class="icon--search"></i> {_ search _}</button>

        {% wire name="show-home-suggestions"
            action={update target="home__search__suggestions-"++#identifier template="global-search/search-query.tpl" pagelen=12 results_template="global-search/search-suggestions.tpl" context=context}
        %}
        <div class="home__search__suggestions" id="home__search__suggestions-{{ #identifier }}"></div>
    </div>
</form>
