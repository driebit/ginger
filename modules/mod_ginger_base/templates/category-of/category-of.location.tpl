<div class="category-of--location">
    <div class="category-of__cat">
        <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
    </div>
    {% if id.address_city %}
        <div class="category-of__location">
            {{ id.address_city }}
        </div>
    {% endif %}
</div>
