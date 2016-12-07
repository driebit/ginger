{% with class|default:"search-suggestions__toggle-search" as class %}
	<a href="#" class="{{ class }} {{ extraClasses }}" id="toggle-search">
	    <i class="icon--search"></i> <span>{_ Search _} </span>
	</a>
{% endwith %}
