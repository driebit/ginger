{% block search_form %}
	<form class="search-form" method="GET" action="{% url search %}">
		<input type="text" class="search-query do_suggestions" value="{{ q.qs|escape }}" name="qs" placeholder="Search" autocomplete="off" />

		{% wire name="show_suggestions"
			action={update target="suggestions" template="_search_suggestions.tpl"}
		%}
	</form>

	<div id="suggestions"></div>
{% endblock %}

{% block search_js %}
	{% lib "js/mod_ginger_search.js" %}
{% endblock %}