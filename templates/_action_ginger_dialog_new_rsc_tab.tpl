{% wire id=#form type="submit" 
	postback={
        new_page
        subject_id=subject_id
        objects=objects|default:[]
        predicate=predicate
        redirect=redirect 
        actions=[{redirect dispatch="ginger_edit_rsc" id=id}]
        callback=callback
    }
	delegate=delegate 
%}

<p></p>
<form id="{{ #form }}" method="POST" action="postback" class="form">

    <input type="hidden" id="{{ #published }}" name="is_published" value="1" />
	<input type="hidden" name="category_id" value="{{ cat }}"/>
	<input type="hidden" name="is_published" value=1/>
	<input type="hidden" name="redirect" value=1/>
	
	<div class="form-group row">
	    <label class="control-label col-md-3" for="new_rsc_title">{_ Title _}</label>
	    <div class="col-md-9">
		<input type="text" id="new_rsc_title" name="new_rsc_title" value="{{ title|escape }}" class="do_autofocus form-control" />
		{% validate id="new_rsc_title" type={presence} %}
	    </div>
	</div>

	{% all include "_ginger_dialog_new_rsc_extra.tpl" cat_id=m.rsc[cat].id cg_id=cg_id %}

    <div class="modal-footer">
	{% button class="btn btn-default" action={dialog_close} text=_"Cancel" tag="a" %}
	<button class="btn btn-primary" type="submit">{_ Make _} {{ catname }}</button>
    </div>

</form>

