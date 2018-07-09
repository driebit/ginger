<div class="modal-body">
    <div class="form-group">
        <label for="geonames_username" class="control-label">{_ GeoNames username _}</label>
        <input type="text" id="geonames_username" name="geonames_username" value="{{ m.config.mod_ginger_geonames.username.value|escape }}" class="form-control do_autofocus" />
        {% wire id="geonames_username" type="change" action={config_toggle module="mod_ginger_geonames" key="username" on="keyup"} %}
    </div>
</div>

<div class="modal-footer">
    {% button class="btn btn-default" text=_"Close" action={dialog_close} tag="a" %}
</div>
