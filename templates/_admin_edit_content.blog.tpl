{% extends "admin_edit_widget_std.tpl" %}

{# To edit the stored search query #}


{% block widget_title %}{_ Search query _}{% endblock %}
{% block widget_show_minimized %}false{% endblock %}


{% block widget_content %}
{% with m.rsc[id] as r %}
<fieldset>
	<div class="notification notice">
		Voeg de code:<br/>
        <blockquote>hasobject=[xxxxx,blogposting]<br/>
        sort=-publication_start</blockquote>
        toe om je blog pagina af te maken.<br/>
        (xxx is de code van de pagina waar je nu op werkt en zie je in je browser balk.)
	</div>

    <div class="form-group">
    	<label class="control-label" for="query">{_ Query _}</label>
    	<div>
    	    <textarea class="form-control" id="{{ #query }}" name="query" rows="15">{{ r.query }}</textarea>
    		{% wire id=#query type="change" postback={query_preview rsc_id=id div_id=#querypreview} delegate="controller_admin_edit" %}
    	</div>
    </div>
    
    <div class="form-group">
    	<div class="checkbox"><label>
    	    <input type="checkbox" id="is_query_live" name="is_query_live" {% if r.is_query_live %}checked{% endif %}/>
    	    {_ Live query, send notifications when matching items are updated or inserted. _}
    	</label></div>
    </div>

	<h3>{_ Query preview _}</h3>
	<div class="query-results" id="{{ #querypreview }}">
		{% include "_admin_query_preview.tpl" result=m.search[{query query_id=id pagelen=20}] %}
	</div>
</fieldset>
{% endwith %}
{% endblock %}
