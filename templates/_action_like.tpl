    {% with btn_class|default:"btn btn-default btn-xs pull-right" as btn_class %}
    {% if m.edge.id[subject_id].interest[object_id]|is_defined %}
        <div id="unlink-undo-message" class="pull-right">
        </div>
        <div id='link-button'>
            {% button text=_"Unlike" class="btn_class"
                action={unlink subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template element_id='link-button'}
                action={hide} 
                action={fade_out target=#notice} 
            %}
        </div>
    {% else %}
        <div id='link-button'>
            {% button text=_"Like" class=btn_class
                action={link subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template element_id='link-button'}
                action={hide} 
                action={fade_out target=#notice} 
            %}
        </div>
    {% endif %}
    {% endwith %}
