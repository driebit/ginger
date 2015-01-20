{% extends "admin_edit_widget_std.tpl" %}

{# Show the edit fields to edit the name of a person #}

{% block widget_title %}{_ Ginger Feed _}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}
{% block widget_id %}content-ginger-feed{% endblock %}

{% block widget_content %}
{% with m.rsc[id] as r %}

	<div class="row">
		<div class="col-lg-12 col-md-12">
			<div class="form-group">
				<label class="control-label" for="{{ #source_post_url }}">{_ Post URL _}</label>
				<div>
					<input class="form-control" id="{{ #source_post_url }}" type="url" name="source_post_url" value="{{ r.source_post_url }}" />
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-12 col-md-12">
			<div class="form-group">
				<label class="control-label" for="{{ #source_user_url }}">{_ User URL _}</label>
				<div>
					<input class="form-control" id="{{ #source_user_url }}" type="url" name="source_user_url" value="{{ r.source_user_url }}" />
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-lg-12 col-md-12">
			<div class="form-group">
				<label class="control-label" for="{{ #source_user_thumbnail_url }}">{_ User thumbnail URL _}</label>
				<div>
					<div class="row">
						<div class="col-lg-10 col-md-10">
							<input class="form-control" id="{{ #source_user_thumbnail_url }}" type="url" name="source_user_thumbnail_url" value="{{ r.source_user_thumbnail_url }}" />
						</div>
						<div class="col-lg-2 col-md-2">
							{% if r.source_user_thumbnail_url %}
								<img class="thumbnail" src="{{ r.source_user_thumbnail_url }}" />
							{% endif %}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

{% endwith %}
{% endblock %}
