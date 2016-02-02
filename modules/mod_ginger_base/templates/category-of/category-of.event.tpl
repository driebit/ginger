{% if id.date_start|date:"Y" %}

    <div class="category-of--event cf">
        <time datetime="{{ id.start_date|date:"Y-F-jTH:i" }}" class="category-of__date">

            <i class="icon--event"></i>
            {{ id.date_start|date:"d-m-Y" }} {% if not id.date_is_all_day and id.date_start|date:"H:i"!="00:00" %}{{ id.date_start|date:"H:i" }} {% endif %}

            {% if id.date_end|date:"Y" %}
                {% with id.date_start|date:"d-m-Y":"UTC" != id.date_end|date:"d-m-Y":"UTC" as show_end_date %}
                {% with id.date_end|date:"H:i"!="00:00" and id.date_end|date:"H:i"!="23:59" and not id.date_is_all_day as show_end_time %}
                    {% if show_end_date or show_end_time %}- {% endif %}
                    {% if show_end_date %}
                        {% if id.date_is_all_day %}{{ id.date_end|date:"d-m-Y":"UTC" }}{% else %}{{ id.date_end|date:"d M Y" }}{% endif %}
                    {% endif %}
                    {% if show_end_time %}
                        {{ id.date_end|date:"H:i" }}
                    {% endif %}
                {% endwith %}
                {% endwith %}
            {% endif %}

        </time>
    </div>

{% endif %}
