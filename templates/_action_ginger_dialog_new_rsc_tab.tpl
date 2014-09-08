{% wire id=#form type="submit" 
	postback={new_ginger_page
                subject_id=subject_id
                predicate=predicate
                redirect=true 
                actions=actions callback=callback}
                delegate=delegate 
%}
<p>{_ Please fill in the title _} {% if not nocatselect %}{_ and the category of the new page._}{% else %}{_ of the new _} {{ m.rsc[cat].title }}.{% endif %} </p>
<form id="{{ #form }}" method="POST" action="postback" class="form">

	<div class="form-group row">
	    <label class="control-label col-md-3" for="new_rsc_title">{_ Page title _}</label>
	    <div class="col-md-9">
		<input type="text" id="new_rsc_title" name="new_rsc_title" value="{{ title|escape }}" class="do_autofocus form-control" />
		{% validate id="new_rsc_title" type={presence} %}
	    </div>
	</div>

	<input type="hidden" name="category_id" value="{{ cat }}"/>
	<input type="hidden" name="is_published" value=1/>
	<input type="hidden" name="redirect" value=1/>
	
	<div class="form-group row">
	    <label class="control-label col-md-3" for="{{ #published }}">{_ Published _}</label>
        <div class="checkbox col-md-9">
		<label>
		    <input type="checkbox" id="{{ #published }}" name="is_published" value="1" 
				{% if subject_id or m.config.mod_admin.rsc_dialog_is_published.value %}checked="checked"{% endif %} />
		</label>
	    </div>
	</div>

    <div class="modal-footer">
	{% button class="btn btn-default" action={dialog_close} text=_"Cancel" tag="a" %}
	<button class="btn btn-primary" type="submit">{_ Make _} {{ catname }}</button>
    </div>

</form>

