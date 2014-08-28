{% if id.is_visible and id.is_published and not id|member:exclude %}
    {% with id.depiction as dep %}
        <li class="grid_item has-overlay">
            <a href="{{ id.page_url }}">
                {% if dep %}
                    <img src="{% image_url dep mediaclass="grid" crop=dep.id.crop_center %}" alt="{{ id.title }}" /> 
                {% else %}
                    <img src="/lib/images/default.jpg" alt="{{ id.title }}" />
                {% endif %}
                {% if id.title or id.summary %}
                    <div class="grid_item-overlay text-overlay">
                        <h3 class="item-title">{{ id.title }}</h3>
                        {% if m.rsc[id].summary %}
                            <p>{{ id.summary|truncate:120 }}</p>
                        {% endif %}
                    </div>
                {% endif %}
                
                <div class="overlay image-overlay"></div>
            </a>
        </li>
    {% endwith %}
{% endif %}
