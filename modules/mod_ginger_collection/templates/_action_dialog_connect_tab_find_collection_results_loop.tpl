{% if result|length %}
    {% with predicate|as_atom as predicate %}
        {% for row in result|make_list|chunk:2 %}
            <div class="row">
                {% for document in row %}
                    {% include "_action_dialog_connect_tab_find_collection_results_item.tpl" document=document %}
                {% endfor %}
            </div>
        {% endfor %}
    {% endwith %}
{% elseif show_no_results %}
    {_ No collection objects found. _}
{% endif %}
