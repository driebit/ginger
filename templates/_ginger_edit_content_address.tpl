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
			<div class="form-group">
				<label class="control-label" for="phone">{_ Telephone _}</label>
				<input class="form-control" id="phone" type="text" name="phone" value="{{ r.phone }}" />
			</div>
			<div class="form-group">
				<label class="control-label" for="phone">{_ Mobile _}</label>
				<input class="form-control" id="phone_mobile" type="text" name="phone_mobile" value="{{ r.phone_mobile }}" />
			</div>
		</div>

		<div class="col-lg-6 col-md-6">
			<div class="form-group">
				<label class="control-label" for="website">{_ Website _}</label>
				<input class="form-control" id="website" type="url" name="website" value="{{ r.website }}" />
			</div>

			{% catinclude "_admin_edit_content_address_email.tpl" r.id %}
		</div>
	</div>
	<div class="row">	
		<div class="col-xs-12">	
			<div class="form-group">
				<label class="control-label" for="address_country">{_ Country _}</label>
				{% if m.modules.active.mod_l10n %}
					<select class="form-control" id="address_country" name="address_country">
						<option value=""></option>
						{% optional include "_l10n_country_options.tpl" country=r.address_country %}
					</select>
				{% else %}
					<input class="form-control" id="address_country" type="text" name="address_country" value="{{ r.address_country }}" />
				{% endif %}
			</div>
		</div>
		{% wire id="address_country" 
				type="change" 
				action={script script="
					if ($(this).val() != '') $('#visit_address').slideDown();
					else $('#visit_address').slideUp();
				"}
		%}
	
		<div id="visit_address" {% if not r.address_country %}style="display:none"{% endif %}>
			<div class="form-group col-lg-6 col-md-6">
				<label class="control-label" for="address_street_1">{_ Street Line 1 _}</label>
				<input class="form-control" id="address_street_1" type="text" name="address_street_1" value="{{ r.address_street_1 }}" />
			</div>

			<div class="form-group col-lg-6 col-md-6">
				<label class="control-label" for="address_city">{_ City _}</label>
				<input class="form-control" id="address_city" type="text" name="address_city" value="{{ r.address_city }}" />
			</div>

			<div class="form-group col-lg-6 col-md-6">
				<label class="control-label" for="address_postcode">{_ Postcode _}</label>
				<input class="form-control" id="address_postcode" type="text" name="address_postcode" value="{{ r.address_postcode }}" />
			</div>			
			<div class="form-group col-lg-6 col-md-6">
				<label class="control-label" for="address_state">{_ State _}</label>
				<input class="form-control" id="address_state" type="text" name="address_state" value="{{ r.address_state }}" />
			</div>
		</div>
	</div>

{% endwith %}
{% endblock %}
