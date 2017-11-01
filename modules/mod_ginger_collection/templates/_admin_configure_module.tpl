<div class="modal-body">
    <div class="form-group">
        <label for="index">{_ Elasticsearch index _}</label>
        <input type="text" class="form-control do_autofocus" id="index" value="{{ m.config.mod_ginger_collection.index.value|escape }}">
        <p class="help-block">{_ Elasticsearch index in which the collection documents are stored. _}</p>
        {% wire id="index" type="blur" action={config_toggle module="mod_ginger_collection" key="index" on="keyup"} %}
    </div>
</div>

<div class="modal-footer">
    {% button class="btn btn-default" text=_"Close" action={dialog_close} tag="a" %}
</div>
