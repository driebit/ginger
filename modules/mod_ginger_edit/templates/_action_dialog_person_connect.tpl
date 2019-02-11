{% with callback|default:q.callback|default:"window.zConnectDoneReload"|escape as callback %}
{% with m.edge.id[subject_id][predicate][object_id] as connection %}

    <div class="clearfix">
    {{ connect_question }}
    {% if connection %}
        <div id="unlink-undo-message" class="pull-right">
        </div>
        <div id='link-button'>
            {% button text=["<i class='glyphicon glyphicon-remove'></i> ",_"No"] class="btn btn-default btn-xs pull-right "
                action={unlink subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template element_id='link-button'}
                action={dialog_close}
                action={redirect id=object_id}
                action={fade_out target=#notice}
            %}
        </div>
    {% else %}
        <div id='link-button'>
            {% button text=_"Yes" class="btn btn-default btn-xs pull-right"
                action={link subject_id=subject_id predicate=predicate object_id=object_id action=action edge_template=edge_template element_id='link-button'}
                action={dialog_close}
                action={redirect id=object_id}
                action={fade_out target=#notice}
            %}
        </div>
    {% endif %}
    </div>

{% endwith %}
{% endwith %}
