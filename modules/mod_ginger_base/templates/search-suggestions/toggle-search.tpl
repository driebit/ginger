{% with class|default:"search-suggestions__toggle-search" as class %}
	<a tabindex="0" href="#" class="{{ class }} {{ extraClasses }}" id="toggle-search">
	    <i class="icon--search"></i> <span>{_ Search _} </span>
	</a>
{% endwith %}
