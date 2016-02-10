{% with m.rsc[id] as r %}
    {% with not id or m.rsc[id].is_editable as is_editable %}
        <div class="row">
            <div class="form-group col-xs-12">
	            <label class="control-label" for="{{ #title }}{{ lang_code_for_id }}">{_ Title _} {{ lang_code_with_brackets }}</label>
                <input type="text" id="{{ #title }}{{ lang_code_for_id }}" name="title{{ lang_code_with_dollar }}" value="{{ is_i18n|if : r.translation[lang_code].title : r.title }}" {% if not is_editable %}disabled="disabled"{% endif %} {% include "_language_attrs.tpl" language=lang_code class="do_autofocus field-title form-control" %}>
            </div>
        </div>

        <div class="row">
            <div class="form-group col-xs-12">
                <label class="control-label" for="{{ #subtitle }}{{ lang_code_for_id }}">{_ Subtitel _} {{ lang_code_with_brackets }}</label>
                <input type="text" id="{{ #subtitle }}{{ lang_code_for_id }}" name="subtitle{{ lang_code_with_dollar }}" value="{{ is_i18n|if : r.translation[lang_code].subtitle : r.subtitle }}" {% if not is_editable %}disabled="disabled"{% endif %} {% include "_language_attrs.tpl" language=lang_code class=" field-subtitle form-control" %}>
            </div>
        </div>

        <div class="row">
            <div class="form-group col-xs-12">
                <label class="control-label" for="summary">{_ Summary _} {{ lang_code_with_brackets }}</label>
                <textarea rows="4" cols="10" id="summary" name="summary{{ lang_code_with_dollar }}" class="ltr intro form-control">{{ id.summary }}</textarea>
            </div>
        </div>
    {% endwith %}
{% endwith %}
