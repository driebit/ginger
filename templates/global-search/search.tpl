{% block button %}
    <a href="#" class="global-search__toggle-search {{ extraClasses }}" id="toggle-search">
        {_ Zoeken _} <i class="icon--search"></i>
    </a>
{% endblock %}

{% block form %}
    {% include "global-search/search-form.tpl" 
        extraFormClassess=extraFormClassess
        identifier=identifier
    %}
{% endblock %}