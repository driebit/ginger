{% block search_form %}
	<form class="search-form" method="GET" action="{% url search %}">
		<p>
            <input type="text" class="search-query do_suggestions" value="{{ q.qs|escape }}" name="qs" placeholder="Search" autocomplete="off" />
            <i class="search-form_icon"></i>
        </p>

		{% wire name="show_suggestions"
			action={update target="suggestions" template="_search_suggestions.tpl"}
		%}
        <div id="suggestions" class="search-form_suggestions"></div>
	</form>
{% endblock %}

{% block search_js %}
	{% lib "js/mod_ginger_search.js" %}
{% endblock %}