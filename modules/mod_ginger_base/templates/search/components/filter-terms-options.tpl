{% with
    q.global_buckets,
    q.local_buckets,
    q.values,
    load_more,
    load_more_items_visible,
    load_more_length
as
    global_buckets,
    local_buckets,
    values,
    load_more,
    load_more_list_length,
    load_more_items_length
%}
    {% with dynamic|if:local_buckets:global_buckets as buckets %}
        <ul class="{{ load_more|if:"do_loadmore":"" }}" data-loadmore-items-length="{{ load_more_items_length }}" data-loadmore-list-length="{{ load_more_list_length }}" >
            {% for bucket in buckets %}
                {% with forloop.counter as i %}
                    <li>
                        <input id="{{ #search_filter_value.i }}" type="checkbox" value="{{ bucket.key}}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                        <label for="{{ #search_filter_value.i }}">{{ bucket.key|escape }} <span>({{ bucket.doc_count }})</span></label>
                    </li>
                {% endwith %}
            {% endfor %}
        </ul>
        {% if load_more and load_more_list_length < buckets|length %} <span class="filter-down-btn"><span class="glyphicon glyphicon-plus">&nbsp;</span>{_ Load more _}</span> {% endif %}
    {% endwith %}
{% endwith %}

