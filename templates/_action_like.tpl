
{% if m.edge.id[subject_id].interest[object_id]|is_defined %}
    {% button text=_"Remove from your collection" class="btn btn-default btn-xs pull-right" 
            action={unlink subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template}
            action={hide} 
            action={fade_out target=#notice} 
    %}
{% else %}
    {% button text=_"Add to your collection" class="btn btn-default btn-xs pull-right" 
            action={link subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template}
            action={hide} 
            action={fade_out target=#notice} 
    %}
{% endif %}
