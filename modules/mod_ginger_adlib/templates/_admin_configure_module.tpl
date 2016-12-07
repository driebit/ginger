<div class="modal-body">
    <div class="control-group">
        <label class="control-label" for="apikey">{_ Adlib API URL _}</label>
        <div class="controls">
            <input type="text" id="adlib_url" name="adlib_url" value="{{ m.config.mod_ginger_adlib.url.value|escape }}" class="form-control do_autofocus" />
            {% wire id="adlib_url" type="blur" action={config_toggle module="mod_ginger_adlib" key="url" on="keyup"} %}
        </div>
    </div>
</div>

<div class="modal-footer">
    {% button class="btn btn-default" text=_"Close" action={dialog_close} tag="a" %}
</div>

