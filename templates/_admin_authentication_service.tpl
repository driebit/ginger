<div class="row">
    <div class="col-md-6">
        <div class="widget">
            <h3 class="widget-header">{_ Ginger Social Import _}</h3>
            <div class="widget-content">

                <p>{_ Settings for the automatic import of postings on social media. _}</p>

                <fieldset>
                    <div class="form-group row">
                        <div class="col-md-9 col-md-offset-3">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" id="pref_ginger_social_import_enabled" name="pref_ginger_social_import_enabled" {% if m.config.mod_ginger_social.import_enabled.value %}checked="checked"{% endif %} value="1" />
                                    {_ Automatically import social postings _}
                                </label>
                                {% wire id="pref_ginger_social_import_enabled" 
                                    action={config_toggle module="mod_ginger_social" key="import_enabled"}
                                %}
                            </div>

                            <select id="pref_ginger_social_import_publish_known" name="pref_ginger_social_import_publish_known">
                                <option value="">
                                    {_ Keep all postings unpublished _}
                                </option>
                                <option value="known" {% if m.config.mod_ginger_social.publish_known.value == 'known' %}selected{% endif %}>
                                    {_ Publish postings from known users _}
                                </option>
                                <option value="all" {% if m.config.mod_ginger_social.publish_known.value == 'all' %}selected{% endif %}>
                                    {_ Publish all imported postings _}
                                </option>
                            </select>
                            {% wire id="pref_ginger_social_import_publish_known" 
                                action={config_toggle module="mod_ginger_social" key="publish_known"}
                            %}
                        </div>
                    </div>
                </fieldset>

            </div>
        </div>
    </div>
</div>
