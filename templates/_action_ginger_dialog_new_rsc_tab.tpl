{% wire id=#form type="submit" 
	postback={new_page subject_id=subject_id predicate=predicate redirect=redirect 
			  actions=actions callback=callback}
	delegate=delegate 
%}

<p>{_ Please fill in the title _} {_ of the new _} {{ m.rsc[cat].title }}.</p>


<form id="{{ #form }}" method="POST" action="postback" class="form-horizontal">

    <fieldset>

	<input type="hidden" name="category_id" value="{{ cat }}"/>
	<input type="hidden" name="is_published" value=1/>

	<div class="control-group">
	    <label class="control-label" for="new_rsc_title">{_ Page title _}</label>
	    <div class="controls">
		<input type="text" id="new_rsc_title" name="new_rsc_title" value="" class="input-block-level do_autofocus" />
		{% validate id="new_rsc_title" type={presence} %}
	    </div>
	</div>

    {#
    <div class="control-group">
	<label class="control-label" for="{{ #summary }}">{_ Summary _}</label>
        <div class="controls">
	    <textarea rows="4" cols="40" id="new_rsc_summery" name="new_rsc_summery" class="input-block-level intro"></textarea>
        </div>
    </div>
    #}

    <div class="modal-footer">
        {% button class="btn" action={dialog_close} text=_"Cancel" tag="a" %}
        <button class="btn btn-primary" type="submit">{_ Make _} {{ catname }}</button>
    </div>

</form>

