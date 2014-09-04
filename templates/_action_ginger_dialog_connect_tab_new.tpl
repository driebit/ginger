<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-new">
	{% include "_action_ginger_dialog_new_rsc_tab.tpl" 
			delegate="action_ginger_edit_dialog_new_rsc" 
			predicate=predicate
			callback=callback
            actions=actions
			cat=cat|default:(m.predicate.object_category[predicate]|first|element:1)
            nocatselect=1
	%}
</div>
