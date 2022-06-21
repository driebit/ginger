{% extends "admin_edit_widget_std.tpl" %}

{# To edit the stored elastic search query #}

{% block widget_title %}
{_ Search query _}
<div class="widget-header-tools"></div>
{% endblock %}

{% block widget_show_minimized %}false{% endblock %}

{% block widget_content %}
<fieldset>
	<p class="notification notice">
		{_ Here you can edit your elasticsearch query. _}
	</p>

    <div class="form-group">
    	<label class="control-label" for="elastic_query">{_ Elasticsearch query _}</label>
    	<div>
    	    {% with "[]" as placeholder %}
    	       <textarea class="form-control" id="{{ #elastic_query }}" name="elastic_query" rows="15" placeholder="{{ placeholder }}">{{ id.elastic_query }}</textarea>
    	    {% endwith %}
    		{% wire id=#elastic_query
                    type="change"
                    postback={elastic_query_preview
                        query_type="beeldenzoeker"
                        rsc_id=id
                        div_id=#elastic_query_preview
                        target_id=#elastic_query
                        index=m.ginger_collection.collection_index
                    }
                    delegate=m.ginger_collection.query_preview_delegate
            %}
    	</div>
    </div>

    <div class="form-group">
        <a id="{{ #test_elastic_query }}" class="btn btn-default">{_ Test query _}</a>
        {% wire id=#test_elastic_query type="click" action={script script="$('#elastic_query').trigger('change')"} %}
    </div>

	<h4>{_ Query preview _}</h4>

	<div class="elastic-query-results" id="{{ #elastic_query_preview }}">
		{% catinclude "_admin_query_preview.tpl" id result=m.search[{beeldenzoeker query_id=id id=id index=m.config.mod_ginger_collection.index.value pagelen=20}] %}
    </div>
</fieldset>
{% endblock %}
