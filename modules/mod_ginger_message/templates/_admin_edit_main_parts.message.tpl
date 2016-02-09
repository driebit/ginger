
{% optional include "_translation_init_languages.tpl" %}

{% catinclude "_admin_edit_basics.tpl" id is_editable=is_editable languages=languages show_header %}

{% catinclude "_admin_edit_body.tpl" id is_editable=is_editable languages=languages show_header %}
{% all catinclude "_admin_edit_content.tpl" id is_editable=is_editable languages=languages %}

{% catinclude "_admin_edit_depiction.tpl" id is_editable=is_editable languages=languages %}

{% include "_admin_edit_content_advanced.tpl" %}
{% include "_admin_edit_content_seo.tpl" %}
