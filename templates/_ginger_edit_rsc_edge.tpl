{# Show an object with an unlink option. Used in the admin_edit #}
{% with m.rsc[object_id].title as title %}
{% sortable id=#unlink_wrapper tag=edge_id %}
<li id="{{ #unlink_wrapper }}" class="menu-item">
    <div>
	    <img class="grippy" src="/lib/images/grippy.png" alt="" />
        <a href="/edit/{{ object_id }}" title="{_ Edit _}">
	    	{% image object_id mediaclass="admin-list-dashboard" %}
        	{{ title|truncate:30|default:"<i>untitled</i>" }}
            <span class="category">{{ object_id.category_id.title|truncate:20 }}</span>
       	</a>
        <span class="btns">
            <button id="{{ #unlink }}" title="{_ Disconnect _}" class="btn btn-default btn-xs"><i class="glyphicon glyphicon-remove"></i></button>
        </span>
    </div>
</li>
{% endwith %}

{% wire id=#unlink action={unlink subject_id=subject_id edge_id=edge_id hide=#unlink_wrapper} %}
