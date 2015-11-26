{% extends "admin_edit_widget_std.tpl" %}

{# Show the edit fields to edit the name of a person #}

{% block widget_title %}{_ Address _}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}content-address{% endblock %}
{% block widget_class %} edit-address {% endblock %}

{% block widget_content %}
{% with m.rsc[id] as r %}
	<div class="row">
		<div class="col-lg-6 col-md-6">
			<div class="form-group address_telephone">
				<label class="control-label" for="phone">{_ Telephone _}</label>
				<input class="form-control" id="phone" type="text" name="phone" value="{{ r.phone }}">
			</div>
			<div class="form-group address_mobile">
				<label class="control-label" for="phone">{_ Mobile _}</label>
				<input class="form-control" id="phone_mobile" type="text" name="phone_mobile" value="{{ r.phone_mobile }}">
			</div>
			<div class="form-group address_facebook">
				<label class="control-label" for="facebook">{_ Facebook _}</label>
				<input class="form-control" id="facebook" type="text" name="facebook" value="{{ r.facebook }}">
			</div>
		</div>

		<div class="col-lg-6 col-md-6">
			<div class="form-group address_website">
				<label class="control-label" for="website">{_ Website _}</label>
				<input class="form-control" id="website" name="website" value="{{ r.website }}">
			</div>
	        <div class="form-group checkbox">
                <label>
                    <input type="checkbox" id="field-is-website=redirect" name="is_website_redirect" value="1"
                        {% if r.is_website_redirect %}checked{% endif %}
                        {% if not is_editable %}disabled="disabled"{% endif %}
                    />
                    {_ Redirect to website on page view _}
                </label>
	        </div>
			<div class="form-group address_twitter">
				<label class="control-label" for="twitter">{_ Twitter _}</label>
				<input class="form-control" id="twitter" type="text" name="twitter" value="{{ r.twitter }}">
			</div>
			<div class="form-group address_linkedin">
				<label class="control-label" for="linkedin">{_ LinkedIn _}</label>
				<input class="form-control" id="linkedin" type="text" name="linkedin" value="{{ r.linkedin }}">
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12 col-md-12">
			{% catinclude "_admin_edit_content_address_email.tpl" r.id %}
		</div>
	</div>
	<div class="row">
		<div class="form-group visit_address_country col-xs-12">
			<label class="control-label" for="address_country">{_ Country _}</label>
            <span class="admin-text-header"></span>
			{% if m.modules.active.mod_l10n %}
				<select class="form-control" id="address_country" name="address_country">
					<option value=""></option>
					{% optional include "_l10n_country_options.tpl" country=r.address_country %}
				</select>
			{% else %}
				<input class="form-control" id="address_country" type="text" name="address_country" value="{{ r.address_country }}">
			{% endif %}
		</div>

		<div id="visit_address" class="visit-address">
			<div class="form-group address_street col-lg-6 col-md-6">
				<label class="control-label" for="address_street_1">{_ Street Line 1 _}</label>
				<input class="form-control" id="address_street_1" type="text" name="address_street_1" value="{{ r.address_street_1 }}">
			</div>

			<div class="form-group address_city col-lg-6 col-md-6">
				<label class="control-label" for="address_city">{_ City _}</label>
				<input class="form-control" id="address_city" type="text" name="address_city" value="{{ r.address_city }}">
			</div>

			<div class="form-group address_zipcode col-lg-6 col-md-6">
				<label class="control-label" for="address_postcode">{_ Postcode _}</label>
				<input class="form-control" id="address_postcode" type="text" name="address_postcode" value="{{ r.address_postcode }}">
			</div>
			<div class="form-group address_state col-lg-6 col-md-6">
				<label class="control-label" for="address_state">{_ State _}</label>
				<input class="form-control" id="address_state" type="text" name="address_state" value="{{ r.address_state }}">
			</div>
		</div>
	</div>

{% endwith %}
{% endblock %}
