{% for key, values in facets %}

    <label>{{ key }}</label>
    <select name="filter_{{key}}" class="form-control">
        <option value="">({_ all _})</option>

        {# Derive currently selected value from selected_facets #}
        {% with selected_facets|element:1|index_of:key as selected_index %}
            {% if selected_index %}
                {% with (selected_facets|element:2)|slice:[selected_index, selected_index+1]|first as selected_value %}
                    {% for name, label, count, uri, value in values %}
                        <option value="{{ value }}"{% if value == selected_value %} selected{% endif %}>{{ label|default:value }} ({{ count }})</option>
                    {% endfor %}
                {% endwith %}
            {% else %}
                <option value="{{ value }}">{{ label|default:value }} ({{ count }})</option>
            {% endif %}
        {% endwith %}
    </select>
{% endfor %}

