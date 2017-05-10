{% with
    q.global_buckets,
    q.local_buckets,
    q.values,
    load_more
as
    global_buckets,
    local_buckets,
    values,
    load_more
%}
    {% with dynamic|if:local_buckets:global_buckets as buckets %}
        {% for bucket in buckets %}
            {% with forloop.counter as i %}
                {% if load_more %}
                    {% with length as length %}
                        <li class="{% if i >= length %} rest-subject hidden {% endif %}">
                            <input id="{{ #search_filter_value.i }}" type="checkbox" value="{{ bucket.key}}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                            <label for="{{ #search_filter_value.i }}">{{ bucket.key|escape }} <span>({{ bucket.doc_count }})</span></label>
                        </li>
                    {% endwith %}
                {% else %}
                    <li>
                        <input id="{{ #search_filter_value.i }}" type="checkbox" value="{{ bucket.key}}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                        <label for="{{ #search_filter_value.i }}">{{ bucket.key|escape }} <span>({{ bucket.doc_count }})</span></label>
                    </li>
                {% endif %}
            {% endwith %}
        {% endfor %}

    {% endwith %}
{% endwith %}

