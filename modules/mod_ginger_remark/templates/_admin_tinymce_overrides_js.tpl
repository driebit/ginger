/*
Custom settings to override tiny-init.js.
*/
{% if m.config.mod_editor_tinymce.version.value < '4.0' %}
	tinyInit.language="en";
{% elseif z_language != `en` and z_language != `nl` and z_language != `ru` %}
	tinyInit.language="en";
{% else %}
	tinyInit.language="{{ z_language|default:"en" }}";
{% endif %}

tinyInit.toolbar="styleselect | bold italic underline removeformat | bullist numlist | removeformat | zmedia | link unlink | code";

{# tinyInit.content_css= "/lib/css/site/editor.css"; #}
tinyInit.style_formats = [  {title: "Headers", items: [
                                {title: "Header 3", format: "h3"},
                                {title: "Header 4", format: "h4"},
                            ]},
                            {title: "Inline", items: [
                                {title: "Bold", icon: "bold", format: "bold"},
                                {title: "Italic", icon: "italic", format: "italic"},
                                {title: "Underline", icon: "underline", format: "underline"},
                                {title: "Strikethrough", icon: "strikethrough", format: "strikethrough"},
                            ]},
                            {title: "Blocks", items: [
                                {title: "Paragraph", format: "p"},
                                {title: "Blockquote", format: "blockquote"},
                            ]}
                        ];tinymce.init({
  selector: 'textarea',  // change this value according to your html
});
