<form class="global-search__searchform {{ extraFormClassess }}" id="global-search__searchform-{{ identifier }}" role="search" action="{% if context %}/{{ context }}_search{% else %}{% url search %}{% endif %}" method="get">
    <div class="global-search__searchform__group">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="hidden" name="qcg" value="{{ cg_name }}" />
        <input type="text"
            class="do_global_search"
            name="qs" 
            value="{{q.qs|escape}}" 
            placeholder="{_ Search _}" 
            autocomplete="off"
            data-param-wire="show-suggestions-{{ identifier }}" 
            data-param-results="global-search__suggestions-{{ identifier }}" 
            data-param-container="global-search-{{ identifier }}"  />
    </div>
    <button type="submit" class="global-search__submit" title="zoek">{_ Search _}</button>
    {% wire name="show-suggestions-"++identifier
        action={update target="global-search__suggestions-"++identifier template="global-search/search-suggestions.tpl" context=context}
    %}
    <div class="global-search__suggestions" id="global-search__suggestions-{{ identifier }}"></div>
</form>