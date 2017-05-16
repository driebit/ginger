/*
Custom settings to override tiny-init.js.
*/

if (typeof tinymce_overrides_language === 'undefined' || !tinymce_overrides_language) {
    tinyInit.language="{{ m.translation.language|default:"en" }}";
}

if (typeof tinymce_overrides_menubar === 'undefined' || !tinymce_overrides_menubar) {
    tinyInit.menubar="";
}

if (typeof tinymce_overrides_toolbar === 'undefined' || !tinymce_overrides_toolbar) {
    tinyInit.toolbar="styleselect | bold italic | bullist numlist | removeformat | zlink zmedia | link unlink | code";
}

if (typeof tinymce_overrides_extended_valid_elements === 'undefined' || !tinymce_overrides_extended_valid_elements) {
    tinyInit.extended_valid_elements="iframe[src|style|width|height|scrolling|marginwidth|marginheight|frameborder]";
}
