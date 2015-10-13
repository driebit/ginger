{% with btn_class|default:"btn btn-default btn-xs pull-right" as btn_class %}
{% with btn_unlike_text|default:_"Unlike" as btn_unlike_text %}
{% with btn_like_text|default:_"Like" as btn_like_text %}

    {% if m.edge.id[subject_id].interest[object_id]|is_defined %}
        <div id='link-button' class='active'>
            {% button text=btn_unlike_text class=btn_class++ " is-active"
                        action={
                            unlink
                            subject_id=subject_id
                            predicate="interest"
                            object_id=object_id
                            action={
                                redirect
                                id=id
                            }
                        }
                action={unlink subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template element_id='link-button'}
                action={hide} 
                action={fade_out target=#notice} 
            %}
        </div>
    {% else %}
        <div id='link-button'>
            {% button text=btn_like_text class=btn_class
                        action={
                            link
                            subject_id=subject_id
                            predicate="interest"
                            object_id=object_id
                            action={
                                redirect
                                id=id
                            }
                        }
            %}
        </div>
    {% endif %}

{% endwith %}
{% endwith %}
{% endwith %}
