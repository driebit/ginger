{% overrules %}

{% block edit_advanced_extra %}
    <div class="form-group row">
        <label class="control-label col-md-3" for="field-alternative-uris">{_ Alternative uris _}</label>
        <div class="col-md-9">
        	<textarea name="alternative_uris" id="field-alternative-uris" class="form-control" rows="3" {% if not is_editable %}disabled="disabled"{% endif %}>{{ r.alternative_uris }}</textarea>
        </div>
    </div>

    <div class="form-group row">
        <label class="control-label col-md-3" for="field-alternative-uris">{_ Website _}</label>
        <div class="col-md-9">
            <input class="form-control" id="website" type="url" name="website" value="{{ r.website }}">
            <label>
                <input type="checkbox" id="field-is-website=redirect" name="is_website_redirect" value="1"
                    {% if r.is_website_redirect %}checked{% endif %}
                    {% if not is_editable %}disabled="disabled"{% endif %}
                />
                {_ Redirect to website on page view _}
            </label>
        </div>
    </div>
{% endblock %}
