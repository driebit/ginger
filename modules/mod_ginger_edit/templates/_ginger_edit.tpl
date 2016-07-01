{% javascript %}
	$('#save-buttons').hide().fadeIn();
{% endjavascript %}

{% block rscform %}

{% with id.is_editable as is_editable %}
{% with m.config.i18n.language_list.list as languages %}
{% with q.page|default:id.page_url as view_location %}
{% wire id="rscform" type="submit" postback={rscform view_location=view_location} delegate=`controller_admin_edit` %}

	<input type="hidden" name="id" id="id" value="{{ id }}" />
    {% validate type={presence} id="id" %}
    <input type="hidden" name="view_location" value="{{ view_location }}" />

    {% block meta_data %}
	<div class="meta-data row">
		<div class="col-lg-10 col-md-10">
			{% block meta_data_first %}{% endblock %}
		</div>

		<div class="col-lg-2 col-md-2">
			<a id="meta-toggle" href="#meta" role="button" class="btn btn-default btn-sm pull-right"><i class="glyphicon glyphicon-cog"></i></a>
			{% javascript %}
			$('#meta-toggle').click(function(e) {
				if ($('#meta-extra').is(":visible")) {
					$('.meta-extra').slideUp();
				} else {
					$('.meta-extra').slideUp();
					$('#meta-extra').slideDown();
				}
				e.preventDefault();
			});
			{% endjavascript %}
		</div>
	</div>
    {% endblock %}

	{% block meta_data_after %}
	{% endblock %}

    {% block meta_extra %}
	<div class="row meta-extra" id="meta-extra" style="display:none; margin-left:0px;; margin-right:0px">
		<ul class="nav nav-tabs">
			{% block meta_tabs %}{% endblock %}
			{% if m.modules.info.mod_translation.enabled %}
				<li><a href="#meta-language" data-toggle="tab">{_ Language _}</a></li>
			{% endif %}
			{# <li><a href="#meta-acl" data-toggle="tab">{_ Access control _}</a></li> #}
			<li><a href="#meta-pubdate" data-toggle="tab">{_ Publication _}</a></li>
		</ul>
		<div class="tab-content">
			{% block meta_panels %}{% endblock %}
			<div class="tab-pane" id="meta-language">
				{% optional include "_translation_edit_languages.tpl" %}
			</div>
			{# <div class="tab-pane" id="meta-acl"> #}
			{#	{% include "_admin_edit_visible_for.tpl" id=id is_admin_frontend %} #}
			{# </div> #}
            <div class="tab-pane publication-dates" id="meta-pubdate">
                <label for="is_published" class="checkbox-inline">
                    {# TODO: if you make a new rsc the rsc is not published (there was a if id is published around the checked=checked) #}
                    <input type="checkbox" id="is_published" name="is_published" value="1" checked="checked"/>
                    {_ Published _}
                </label>

                {% include "_edit_date.tpl" date=id.publication_start name="publication_start" is_end=0 %}
                {_ till _}
                {% include "_edit_date.tpl" date=id.publication_end name="publication_end" is_end=1 %}
            </div>
		</div>

		{% javascript %}
			$('#meta-extra .nav-tabs a:first').tab('show');
		{% endjavascript %}
	</div>
    {% endblock %}

    {% block edit_blocks %}
        <div id="poststuff">
	    {% optional include "_translation_init_languages.tpl" %}
		{% catinclude "_ginger_edit_basics.tpl" id is_editable=is_editable languages=languages %}

		{% all catinclude "_admin_edit_content.tpl" id is_editable=is_editable languages=languages %}

        {% if id.category_id.feature_show_address|if_undefined:`true` %}
            {% catinclude "_admin_edit_content_address.tpl" id is_editable=is_editable languages=languages %}
        {% endif %}
        {% if id.category_id.feature_show_geodata|if_undefined:`true` %}
            {% optional include "_geomap_admin_location.tpl" %}
        {% endif %}

		{% if id.is_a.media or id.medium %}
			{% include "_admin_edit_content_media.tpl" %}
		{% endif %}

		{% catinclude "_admin_edit_body.tpl" id is_editable=is_editable languages=languages %}
		{# catinclude "_admin_edit_blocks.tpl" id is_editable=is_editable languages=languages #}
		{% catinclude "_ginger_edit_depiction.tpl" id is_editable=is_editable languages=languages show_opened tab="upload" tabs_enabled=["upload","video","video_embed"] %}
        </div>
    {% endblock %}

    {% block form_save %}
    	{# Hidden safe buttons and publish state - controlled via the nabvar #}
    	<div style="display: none">
    		<span id="button-prompt">{% block nav_prompt %}{{ id.category_id.title }}{% endblock %}</span>

    		{% block buttons %}
    			{% button type="submit" id="save_stay" class="btn btn-primary" text=_"Save" title=_"Save this page." disabled=not id.is_editable %}

    			{% if id.is_editable %}
    				{% button type="submit" id="save_view" class="btn btn-default" text=_"Save &amp; view" title=_"Save and view the page." %}
    			{% else %}
    				{% button id="save_view" class="btn btn-primary" text=_"View" title=_"View this page." action={redirect id=id} %}
    			{% endif %}
    		{% endblock %}
    	</div>
    {% endblock %}
{% endwith %}
{% endwith %}
{% endwith %}

{% javascript %}
    $(document).on('keypress', ':input:not(textarea)', function (e) {
       if (e.which == 13) e.preventDefault();
    });
{% endjavascript %}

{% endblock %}
