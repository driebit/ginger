{% if id.is_editable %}
	<div class="edit-btns">
	        <a class="btn btn-mini" id="{{ #unlink }}" title="{_ Disconnect _}"><i class="glyphicon glyphicon-remove"></i></button>
	        <a class="btn btn-mini" href="/edit/{{ list_item.id }}" title="{{ title|default:_"Edit" }}"><i class="glyphicon glyphicon-edit"></i></a>
	</div>

	{% wire id=#unlink action={unlink subject_id=subject_id edge_id=edge_id hide=#unlink_wrapper} %}
	{% wire id=#edit target=#unlink_wrapper action={dialog_edit_basics edge_id=edge_id} %}

{% endif %}


