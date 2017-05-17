/*
Custom settings to override tiny-init.js.
*/

if (typeof tinyInit.language === 'undefined') {
    tinyInit.language="{{ m.translation.language|default:"en" }}";
}

if (typeof tinymce_overrides_menubar === 'undefined' || !tinymce_overrides_menubar) {
    tinyInit.menubar="";
}

if (typeof tinymce_overrides_toolbar === 'undefined' || !tinymce_overrides_toolbar) {
    tinyInit.toolbar="styleselect | bold italic | bullist numlist | removeformat | zlink zmedia | link unlink | code";
}

tinyInit.extended_valid_elements+="iframe[src|style|width|height|scrolling|marginwidth|marginheight|frameborder]";
