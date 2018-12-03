<div id="dialog_connect_results" class="connect-results">
    {% if text %}
        {% with m.geonames[{search text=text}] as places %}
            <div id="dialog_connect_loop_geonames_results" class="thumbnails">
                {% include "_action_dialog_connect_tab_find_geonames_results_loop.tpl" result=places %}
            </div>
        {% endwith %}
    {% else %}
        {# Reverse geo lookup based on the page’s geo coordinates #}
        {% if [subject_id]|location_defined %}
            {% with m.geonames[{geo_lookup id=subject_id}] as places %}
                <div id="dialog_connect_loop_geonames_results" class="thumbnails">
                    {% include "_action_dialog_connect_tab_find_geonames_results_loop.tpl" result=places|reversed %}
                </div>
            {% endwith %}
        {% else %}
            {_ The page has no location coordinates. _}
        {% endif %}
    {% endif %}
</div>
