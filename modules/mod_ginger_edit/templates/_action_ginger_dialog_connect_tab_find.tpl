<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-find">
	<p>{_ Find an existing page to connect _}</p>

	<form id="dialog-connect-find" class="row">
        <input type="hidden" name="find_category" id="find_category" value="{{ cat }}">
		<input type="hidden" name="subject_id" value="{{ subject_id }}" />
        <input type="hidden" name="object_id" value="{{ object_id }}" />
		<input type="hidden" name="predicate" value="{{ predicate|default:'' }}" />
        <div class="col-md-8">
		    <input name="find_text" type="text" value="" placeholder="{_ Type text to search _}" class="do_autofocus form-control" />
        </div>

        <div class="col-md-4">
            {% block category_select %}
	        {% endblock %}
        </div>
	</form>

	<div id="dialog-connect-found" class="do_feedback"
		data-feedback="trigger: 'dialog-connect-find', delegate: 'mod_admin'">
	</div>

    <div class="modal-footer">
        <a class="btn btn-default" id="{{ #close }}">
         {% if autoclose %}{_ Cancel _}{% else %}{_ Ok _}{% endif %}
        </a>
        {% wire id=#close action={dialog_close} %}
    </div>
</div>
{% wire name="dialog_connect_find"
    action={postback
        delegate=delegate|default:"mod_admin"
        postback={admin_connect_select
            id=id
            subject_id=subject_id
            object_id=object_id
            predicate=predicate
            callback=callback
            language=language
            action=action
            actions=actions
        }
    }
%}
{% javascript %}
    $('#dialog-connect-find').change();
    $("#dialog-connect-found").on('click', '.thumbnail', function(e) {
    	e.preventDefault();
        $(this).effect("highlight").addClass("thumbnail-connected");
        z_event('dialog_connect_find', {
            select_id: $(this).data('id')
        });
    });

    $('a[data-toggle="tab"]').click(function(){
        var id = $(this).data('id');
        $('#find_category').val(id);
        $('#dialog-connect-find').change();
    });
{% endjavascript %}
