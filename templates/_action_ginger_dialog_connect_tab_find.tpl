<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-find">
	<p>{_ Find an existing page to connect _}</p>

	<form id="dialog-connect-find" class="row">
        <div class="col-md-8">
		    <input name="find_text" type="text" value="" placeholder="{_ Type text to search _}" class="do_autofocus form-control" />
        </div>

        <div class="col-md-4">
            
		    {% block category_select %}
		        <input type="hidden" name="find_category" value="{{ cat }}">
	        {% endblock %}
        </div>
	</form>

	<div id="dialog-connect-found" class="do_feedback"
		data-feedback="trigger: 'dialog-connect-find', delegate: 'mod_ginger_edit'">
	</div>
</div>

{% javascript %}

    $('#dialog-connect-find').change();

    $("#dialog-connect-found").on('click', '.thumbnail', function() {
	z_notify("admin-connect-select", { 
	z_delegate: "mod_admin", 
	select_id: $(this).data('id'),
	predicate: '{{ predicate }}',
	object_id: '{{ subject_id }}',
	callback: '{{ callback }}',
	language: '{{ language }}'
	});
    });
{% endjavascript %}
