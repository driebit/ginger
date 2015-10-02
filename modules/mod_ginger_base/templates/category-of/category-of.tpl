{% with
    class|default:"category-of"
as
    class
%}

<div class="{{ class }}">
    <i class="icon--{{ id.category.name }}"></i>{{ m.rsc[id.category.id].title }}
</div>

{% endwith %}
