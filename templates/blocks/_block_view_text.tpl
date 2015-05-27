<div id="{% if blk.title %}{{ blk.title|slugify }}{% else %}{{ blk.id }}{% endif %}" class="block--text {% if first %}first {% endif %}">
    {{ blk.body|show_media }}
</div>