<div class="category-of--location">
    <div class="category-of__cat">
        <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
    </div>
    {% if id.city %}
        <div class="category-of__location">
            {{ id.city }}
        </div>
    {% endif %}
</div>
