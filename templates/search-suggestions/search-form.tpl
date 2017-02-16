
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

<form class="{{ formclass }} {{ extraFormClassess }}" id="search-suggestions__searchform-{{ #identifier }}" role="search" action="{% url beeldenzoeker_search %}" method="get">
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
    <div class="search-suggestions__searchform__options">
    	<div class="{{ wrapperclass }}">
	    	<div class="search-suggestions__searchform__options__option--radio">
	    		<input type="radio" id="museumcollection{{ #identifier }}" name="selection" checked><label for="museumcollection{{ #identifier }}">{_ Full museum collection _}</label>
	    	</div>
	    	<div class="search-suggestions__searchform__options__option--radio">
	    		<input type="radio" id="events{{ #identifier }}" name="selection"><label for="events{{ #identifier }}">{_ Events _}</label>
	    	</div>
	    	<div class="search-suggestions__searchform__options__option--checkbox">
	    		<input type="checkbox" id="imagesonly{{ #identifier }}"><label for="imagesonly{{ #identifier }}">{_ Only images _}</label>
	    	</div>
	    </div>
    </div>
</form>

{% endwith %}
