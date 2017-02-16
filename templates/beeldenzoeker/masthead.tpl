{% if record.reproduction|first as reproduction %}
	<div class="masthead {{ extraClasses }}" style="background-image: url({% include "beeldenzoeker/image-url.tpl" width="1600" height="1600" %}); background-size: cover;">


		<a href="{% include "beeldenzoeker/image-url.tpl" width="1600" height="1600" %}" class="masthead__zoom" title="{_ Zoom _}"><i class="icon--expand"></i></a>

{% else %}
	<div class="masthead no-image">
{% endif %}
</div>