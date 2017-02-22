<label class="control-label">{_ Sync databases _}</label>
{% with m.config.mod_ginger_adlib.databases.list as current %}
    {% for database in m.ginger_adlib.listdatabases %}
        {% with database.database|first as database_name %}
            {% with "adlib_database_" ++ database.database|first as input_id %}
                <div class="checkbox">
                    <label for="{{ input_id }}">
                        <input type="checkbox" name="adlib_database" id="{{ input_id }}" value="{{ database_name }}"{% if current|index_of:database_name > 0 %} checked="checked"{% endif %}/>
                        {% wire id=input_id postback={toggle_database database=database_name} delegate=`m_ginger_adlib` %}
                        {{ database_name }}
                    </label>
                </div>
            {% endwith %}
        {% endwith %}
    {% endfor %}

{% endwith %}
