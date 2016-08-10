<p>{_ Add RFID code to a person. _}</p>

{% wire id=#form type="submit" postback={add_rfid id=id} delegate=`mod_ginger_tagger` %}
<form id="{{ #form }}" method="POST" action="postback" class="form form-horizontal">

    <div class="form-group row">
        <label class="control-label col-md-4" for="rfid">{_ Hexadecimal RFID code _}</label>
        <div class="col-md-3">
            <input class="form-control" type="text" id="rfid" name="rfid" />
            {% validate id="rfid" type={length minimum=6} %}
        </div>
    </div>

    <div class="modal-footer clearfix">
	    {% button class="btn btn-default" action={dialog_close} text=_"Cancel" %}
	    {% button class="btn btn-primary" text=_"Save" %}
    </div>
</form>
