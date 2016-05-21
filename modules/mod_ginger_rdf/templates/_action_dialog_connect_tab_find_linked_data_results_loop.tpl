{% if result|length %}
    {% with predicate|as_atom as predicate %}
        {% for row in result|make_list|chunk:2 %}
            <div class="row">
                {% for item in row %}
                    {% include "_action_dialog_connect_tab_find_linked_data_results_item.tpl" rdf=item %}
                {% endfor %}
            </div>
        {% endfor %}
    {% endwith %}
{% elseif show_no_results %}
    {_ No linked data found. _}
{% endif %}
