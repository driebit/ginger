{# Remove this template when zotonic 0.50.0 is on production #}

{% overrules %}
{% block category %}
    <div class="form-group row">
        <label class="control-label col-md-3" for="{{ #category }}">{_ Category _}</label>
        <div class="col-md-9">
            {% if cat and nocatselect %}
                <input class="form-control" type="text" readonly value="{{ m.rsc[cat].title }}">
                <input type="hidden" name="category_id" value="{{ cat }}">
            {% else %}
                {% block category_select %}
                    <select class="form-control" id="{{ #category }}" name="category_id" required>
                        <option value="" disabled {% if not cat %}selected{% endif %}>{_ Select category _}</option>
                        {% for c in m.category.tree_flat %}
                            {% if m.acl.insert[c.id.name|as_atom]
                                  and (not cat or m.category[c.id].is_a[cat])
                                  and (not subject_id or predicate|is_undefined or m.predicate.is_valid_object_category[predicate][c.id])
                                  and (not object_id  or predicate|is_undefined or m.predicate.is_valid_subject_category[predicate][c.id])
                            %}
                                <option value="{{c.id}}" {% if c.id == cat %}selected="selected" {% endif %}>
                                    {{ c.indent }}{{ c.id.title|default:c.id.name }}
                                </option>
                            {% endif %}
                        {% endfor %}
                    </select>
                    {% validate id=#category name="category_id" type={presence} only_on_submit %}
                {% endblock %}
            {% endif %}
        </div>
    </div>
{% endblock %}
