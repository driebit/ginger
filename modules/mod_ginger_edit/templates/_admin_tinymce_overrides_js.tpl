/*
Custom settings to override tiny-init.js.
*/

if (typeof tinyInit.language === 'undefined') {
    {% if m.config.mod_editor_tinymce.version.value < '4.0' %}
        tinyInit.language="en";
    {% elseif z_language != `en` and z_language != `nl` and z_language != `ru` %}
        tinyInit.language="en";
    {% else %}
        tinyInit.language="{{ z_language|default:"en" }}";
    {% endif %}
}

if (typeof tinymce_overrides_menubar === 'undefined' || !tinymce_overrides_menubar) {
    tinyInit.menubar="";
}

if (typeof tinymce_overrides_toolbar === 'undefined' || !tinymce_overrides_toolbar) {
    tinyInit.toolbar="styleselect | bold italic | bullist numlist | removeformat | zlink zmedia | link unlink | code";
}

tinyInit.extended_valid_elements+="iframe[src|style|width|height|scrolling|marginwidth|marginheight|frameborder]";
