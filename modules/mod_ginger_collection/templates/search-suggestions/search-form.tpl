
{% with
    formclass|default:"search-suggestions__searchform",
    togglebutton|default:"toggle-search",
    wrapperclass|default:"search-suggestions__searchform__group",
    buttonclass|default:"search-suggestions__submit",
    suggestionsclass|default:"search-suggestions__suggestions",
    placeholder|default:_"Search",
    buttonlabel|if_undefined:_"Search",
    iconclass
as
    formclass,
    togglebutton,
    wrapperclass,
    buttonclass,
    suggestionsclass,
    placeholder,
    buttonlabel,
    iconclass
%}

<form name="{{ name }}" class="{{ formclass }} {{ extraFormClassess }}" id="search-suggestions__searchform-{{ #identifier }}" role="search" action="{% url collection_search %}" method="get">
    <div class="{{ wrapperclass }}">
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
          <button type="submit" class="{{ buttonclass }}" title="{_ Search _}">
          {% if iconclass %}
            <i class="{{ iconclass }}"></i>
          {% endif %}
          {{ buttonlabel }}
        </button>

          {% block search_suggestions_wire %}
            {% wire name="show-suggestions-"++#identifier
                action={update target="search-suggestions__suggestions-"++#identifier template="beeldenzoeker/search-suggestions/search-query.tpl" pagelen=12 results_template="search-suggestions/search-suggestions.tpl" context=context}
            %}
          {% endblock %}

        <div class="{{ suggestionsclass }}" id="search-suggestions__suggestions-{{ #identifier }}"></div>
    </div>
</form>

{% endwith %}
