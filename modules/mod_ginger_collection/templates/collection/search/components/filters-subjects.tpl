{% with
    q.buckets,
    q.values,
    title|default:_"Subjects"
as
    buckets,
    values,
    title
%}

    <div class="search__filters__section is-open" id="filter_subjects">
        <h3 class="search__filters__title">{{ title }}</h3>
        <ul class="do_search_cmp_filters_subjects">

        {% for bucket in buckets %}
            {% with forloop.counter as i %}
                <li>
                    <input name="filter-subjects" id="{{ #filter_subjects_value.i }}" type="checkbox" value="{{ bucket.key}}"{% if values|index_of:(bucket.key) > 0 %} checked="checked"{% endif %}>
                    <label for="{{ #filter_subjects_value.i }}">{{ bucket.key }} <span>({{ bucket.doc_count }})</span></label>
                </li>
            {% endwith %}
        {% endfor %}

        </ul>
    </div>

{% endwith %}

{% wire name="update_filter_subjects" action={update target="filter_subjects" template="collection/search/components/filters-subjects.tpl"} %}
