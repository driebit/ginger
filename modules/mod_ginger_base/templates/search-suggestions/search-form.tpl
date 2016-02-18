
{% with
    formclass|default:"search-suggestions__searchform",
    togglebutton|default:"toggle-search",
    wrapperclass|default:"search-suggestions__searchform__group",
    buttonclass|default:"search-suggestions__submit",
    suggestionsclass|default:"search-suggestions__suggestions",
    placeholder|default:_"Search",
    iconclass
as
    formclass,
    togglebutton,
    wrapperclass,
    buttonclass,
    suggestionsclass,
    placeholder,
    iconclass
%}

<form class="{{ formclass }} {{ extraFormClassess }}" id="search-suggestions__searchform-{{ #identifier }}" role="search" action="{% if context %}/{{ context }}_search{% else %}{% url search %}{% endif %}" method="get">
    <div class="{{ wrapperclass }}">
        <input type="hidden" name="qsort" value="{{ q.qsort|escape }}" />
        <input type="hidden" name="qcat" value="{{ q.qcat|escape }}" />
        <input type="hidden" name="qcg" value="{{ cg_name }}" />
        <input type="text"
            class="do_search_suggestions"
            name="qs"
            value="{{q.qs|escape}}"
            placeholder="{{ placeholder }}"
            autocomplete="off"
            data-param-wire="show-suggestions-{{ #identifier }}"
            data-param-results="search-suggestions__suggestions-{{ #identifier }}"
            data-param-togglebutton="{{ togglebutton }}"
          />
    </div>
    <button type="submit" class="{{ buttonclass }}" title="{_ Search _}">
      {% if iconclass %}
        <i class="{{ iconclass }}"></i>
      {% endif %}
      {_ Search _}
    </button>
    {% wire name="show-suggestions-"++#identifier
        action={update target="search-suggestions__suggestions-"++#identifier template="search-suggestions/search-query.tpl" pagelen=12 results_template="search-suggestions/search-suggestions.tpl" context=context}
    %}
    <div class="{{ suggestionsclass }}" id="search-suggestions__suggestions-{{ #identifier }}"></div>
</form>

{% endwith %}
