<div id="dialog_connect_results" class="connect-results">

    {% if text %}
        {% with m.search[{rdf pagelen=10 text=text|default:"*" filters=filters}] as result %}

            <div class="form-group">
                {% block facets %}
                <div id="{{ #linked_data_facets }}">
                    {# Lazy-load search facets #}
                    {% wire action={search_facets target=#linked_data_facets text=text filters=filters template="rdf/search/_facets.tpl"} %}
                </div>
                {% endblock %}
            </div>

            <p>{% if result|length > 0 %}{{ result.total }} {_results_}{% endif %}</p>

            <div id="dialog_connect_loop_linked_data_results" class="thumbnails">
                {% include "_action_dialog_connect_tab_find_linked_data_results_loop.tpl"
                    id
                    result=result
                    show_no_results
                %}
            </div>
            {% lazy
                action={
                    moreresults
                    result=result
                    target="dialog_connect_loop_linked_data_results"
                    template="_action_dialog_connect_tab_find_linked_data_results_loop.tpl"
                    is_result_render
                    visible
                }
            %}
        {% endwith %}
    {% else %}
        {# No query text #}
    {% endif %}
</div>
