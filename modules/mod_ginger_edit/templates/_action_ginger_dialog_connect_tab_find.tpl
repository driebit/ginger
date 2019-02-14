{% with dialog_help_text|default:_"Find an existing page to connect" as dialog_help_text %}
    <div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-find">

        <p>{% if not hide_help_text %}{{ dialog_help_text }}{% endif %}</p>

    	<form id="ginger-dialog-connect-find" class="row">
            <input type="hidden" name="find_category" id="find_category" value="{{ cat }}">
            <input type="hidden" name="cat_exclude" id="cat_exclude" value="{{ cat_exclude }}">
            <input type="hidden" name="find_cg" id="find_cg" value="{{ content_group }}">
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
    		data-feedback="trigger: 'ginger-dialog-connect-find', delegate: 'mod_ginger_edit'">
        </div>

        <div class="modal-footer">
            <a class="btn btn-default" id="{{ #close }}">
             {% if autoclose %}{_ Cancel _}{% else %}{_ Ok _}{% endif %}
            </a>
            {% wire id=#close action={dialog_close} %}
        </div>

    </div>
{% endwith %}
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
            direction=direction
        }
    }
%}
{% javascript %}
    $('#ginger-dialog-connect-find').submit(function() { return false; });
    $('#ginger-dialog-connect-find').change();
    $("#dialog-connect-found").on('click', '.thumbnail', function(e) {
    	e.preventDefault();
        z_event('dialog_connect_find', {
            select_id: $(this).data('id'),
            is_connected: $(this).hasClass('thumbnail-connected')
        });
        $(this).effect("highlight").toggleClass("thumbnail-connected");
    });

    $('a[data-toggle="tab"]').click(function(){
        var id = $(this).data('id');
        $('#find_category').val(id);
        $('#ginger-dialog-connect-find').change();
    });
{% endjavascript %}
