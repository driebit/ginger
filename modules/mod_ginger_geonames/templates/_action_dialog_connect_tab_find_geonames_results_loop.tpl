{% if result|length %}
    {% with predicate|as_atom as predicate %}
        {% for row in result|make_list|chunk:2 %}
            <div class="row">
                {% for place in row %}
                    {% include "_action_dialog_connect_tab_find_geonames_results_item.tpl" place=place %}
                {% endfor %}
            </div>
        {% endfor %}
    {% endwith %}
{% elseif show_no_results %}
    {_ No GeoNames places found. _}
{% endif %}
