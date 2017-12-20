<div id="dialog_connect_results" class="connect-results">
    {% with m.search[{ginger_collection index=m.config.mod_ginger_collection.index.value pagelen=10 text=text|default:"" filters=filters}] as result %}
        <div class="form-group">
            {% block facets %}
            {% endblock %}
        </div>

        {% block results %}
            <p>{% if result|length > 0 %}{{ result.total }} {_ results _}{% endif %}</p>
        {% endblock %}

        <div id="dialog_connect_loop_collection_results" class="thumbnails">
            {% include "_action_dialog_connect_tab_find_collection_results_loop.tpl"
                id
                result=result
                show_no_results
            %}
        </div>
        {% lazy
            action={
                moreresults
                result=result
                target="dialog_connect_loop_collection_results"
                template="_action_dialog_connect_tab_find_collection_results_loop.tpl"
                is_result_render
                visible
            }
        %}
    {% endwith %}
</div>
