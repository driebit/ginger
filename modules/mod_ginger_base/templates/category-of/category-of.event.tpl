{% if id.date_start|date:"Y" %}
    <div class="category-of--event cf">
        <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="category-of__date">
            <i class="icon--{{ id.category.name }}"></i>
            {{ id.date_start|date:"d-m-Y" }} {% if (id.date_start|date:"d-m-Y" != id.date_end|date:"d-m-Y") and id.date_end|date:"Y" %}- {{ id.date_end|date:"d-m-Y" }} {% endif %}
        </time>
        {% if not id.date_is_all_day %}
            <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="category-of__time">
                {{ id.date_start|date:"H:i" }} {% if id.date_end %}- {{ id.date_end|date:"H:i" }}{% endif %}
            </time>
        {% endif %}
    </div>
{% endif %}
