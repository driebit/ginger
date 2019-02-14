{% with
    q.buckets,
    q.values
as
    buckets,
    values
%}
    {% for bucket in buckets %}
        {% with
            forloop.counter,
            m.creative_commons[bucket.key].label
        as
            i,
            label
        %}
            <li>
                <input name="filter_license" id="{{ #filter_license_value.i }}" type="checkbox" value="{{ bucket.key|escape }}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                <label for="{{ #filter_license_value.i }}">
                    {% for part in label|lower|split:"-" %}
                        <i class="icon-cc icon--cc-{{ part }}"></i>
                    {% endfor %}
                </label>
            </li>
        {% endwith %}
    {% endfor %}
{% endwith %}

