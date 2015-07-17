 <a href="" class="global-nav__actions__toggle-search">
    {_ Zoeken _} <i class="icon--profile"></i>
</a>

<form class="global-nav__actions__search {{ extraClasses }}" id="global-nav__actions__search-{{ identifier }}" role="search" action="{% if context %}/{{ context }}_search{% else %}{% url search %}{% endif %}" method="get">
    <div class="global-nav__actions__search__group">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="hidden" name="qcg" value="{{ cg_name }}" />
        <input type="text"
            class="do_search"
            name="qs" 
            value="{{q.qs|escape}}" 
            placeholder="{_ Zoeken _}" 
            autocomplete="off"
            data-param-wire="show-suggestions-{{ identifier }}" 
            data-param-results="global-nav__actions__search__suggestions-{{ identifier }}" 
            data-param-container="global-nav__actions__search-{{ identifier }}"  />
    </div>
    <button type="submit" class="global-nav__actions__search__submit" title="zoek">{_ Zoeken _}</button>
    {% wire name="show-suggestions-"++identifier
        action={update target="global-nav__actions__search__suggestions-"++identifier template="global-nav/global-nav__actions__search__suggestions.tpl" context=context}
    %}
    <div class="global-nav__actions__search__suggestions" id="global-nav__actions__search__suggestions-{{ identifier }}"></div>
</form>

