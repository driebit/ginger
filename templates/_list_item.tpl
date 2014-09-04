{% if id.is_visible and id.is_published and not id|member:exclude %}
    {% with id.depiction as dep %}
            <a href="{{ id.page_url }}" class="list-group-item">
                {% if dep %}
                    <img src="{% image_url dep mediaclass="list_item" crop=dep.id.crop_center %}" alt="{{ id.title }}" /> 
                {% else %}
                    <img src="/lib/images/default.jpg" alt="{{ id.title }}" />
                {% endif %}
                {% if id.title or id.summary %}
                        <h3 class="list-group-item-heading">{{ id.title }}</h3>
                        {% if m.rsc[id].summary %}
                            <p class="list-group-item-text">{{ id.summary|truncate:120 }}</p>
                        {% endif %}
                {% endif %}
            </a>
    {% endwith %}
{% endif %}
