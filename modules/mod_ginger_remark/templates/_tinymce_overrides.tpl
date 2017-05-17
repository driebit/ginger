if (typeof tinymce_overrides_toolbar === 'undefined' || !tinymce_overrides_toolbar) {
   tinyInit.toolbar="styleselect | bold italic | bullist numlist | removeformat | zmedia | link unlink | code";
}

if (typeof tinyInit.style_formats === 'undefined') {
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
                            ];
}
