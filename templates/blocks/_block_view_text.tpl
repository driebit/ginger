{% if blk.style == 'quote' %}
	<blockquote>
		{{ blk.body|show_media }}
	</blockquote>
{% else %}
	<div class="{% if blk.style == 'aside' %}block--aside{% else %}block--text{% endif %}">{{ blk.body|show_media }}</div>
{% endif %}
