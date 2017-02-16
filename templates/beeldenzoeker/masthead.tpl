{% if record.reproduction|first as reproduction %}
	<div class="masthead {{ extraClasses }}" style="background-image: url({{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=1600&height=1600); background-size: cover;">


		<a href="{{ m.config.mod_ginger_adlib.url.value}}?server=images&command=getcontent&value={{ reproduction['reproduction.reference'] }}&width=1600&height=1600" class="masthead__zoom" title="{_ Zoom _}"><i class="icon--expand"></i></a>
		
{% else %}
	<div class="masthead">
{% endif %}
</div>