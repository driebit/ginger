
{% if m.modules.active.mod_acl_user_groups %}
    {% if nocgselect%}
        <input type="hidden" name="content_group_id" value="{{ cg_id }}"/>
    {% else %}
        <div class="form-group row">
            <label class="control-label col-md-3" for="{{ #content_group_id }}">{{ m.rsc.content_group.title }}</label>
            <div class="col-md-9">
                <select class="form-control" id="{{ #content_group_id }}" name="content_group_id">
                    {% for cg in m.hierarchy.content_group.tree_flat %}
                        {% if m.acl_rule.can_insert[cg.id][cat_id] %}
                            <option value="{{ cg.id }}" {% if cg.id == cg_id %}selected{% endif %}>
                                {{ cg.indent }} {{ cg.id.title }}
                            </option>
                        {% endif %}
                    {% endfor %}
                </select>
            </div>
        </div>
    {% endif %}
{% endif %}
