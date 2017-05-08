{% with
    q.global_buckets,
    q.local_buckets,
    q.values
as
    global_buckets,
    local_buckets,
    values
%}
    {% with dynamic|if:local_buckets:global_buckets as buckets %}

        {% for bucket in buckets %}
            {% with forloop.counter as i %}
                <li>
                    <input id="{{ #search_filter_value.i }}" type="checkbox" value="{{ bucket.key}}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                    <label for="{{ #search_filter_value.i }}">{{ bucket.key|escape }} <span>({{ bucket.doc_count }})</span></label>
                </li>
            {% endwith %}
        {% endfor %}

    {% endwith %}
{% endwith %}
