{% with m.rsc[id] as r %}
    {% with not id or m.rsc[id].is_editable as is_editable %}
        <div class="row">
            <div class="form-group col-xs-12">
	            <label class="control-label" for="{{ #title }}{{ lang_code_for_id }}">{_ Title _} {{ lang_code_with_brackets }}</label>
                <div class="">
	                <input type="text" id="{{ #title }}{{ lang_code_for_id }}" name="title{{ lang_code_with_dollar }}" 
		                value="{{ is_i18n|if : r.translation[lang_code].title : r.title }}"
		                {% if not is_editable %}disabled="disabled"{% endif %}
		                {% include "_language_attrs.tpl" language=lang_code class="do_autofocus field-title form-control" %}
                    />
                </div>
            </div>
        </div>
    {% endwith %}
{% endwith %}
