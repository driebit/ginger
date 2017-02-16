{% with 
	width|default:400,
	height|default:400
as 

	width,
	height
%}

	{% block url %}
		{{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width={{ width }}&height={{ width }}
	{% endblock %}
	
{% endwith %}