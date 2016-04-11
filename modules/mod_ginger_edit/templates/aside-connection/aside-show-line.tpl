{% with m.rsc[id] as id %}
<div class="unlink-wrapper">
<ul class="tree-list connections-list">
<li class="menu-item">
    <div>
        <a href="#" title="Bewerken">
	    	{{ id.title }} <span class="category">{{ m.rsc[id.category_id].title }}</span>
       	</a>
    </div>
</li>
</ul>
</div>
<hr />
{% endwith %}