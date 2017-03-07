{% if record.reproduction|filter:'value'|first as reproduction %}
	<div class="masthead {{ extraClasses }}" style="background-image: url({% include "beeldenzoeker/image-url.tpl" image=reproduction.value %});">
		<a href="{% include "beeldenzoeker/image-url.tpl" image=reproduction.value %}" class="masthead__zoom" title="{_ Zoom _}"><i class="icon--expand"></i></a>
{% else %}
	<div class="masthead no-image">
{% endif %}
</div>