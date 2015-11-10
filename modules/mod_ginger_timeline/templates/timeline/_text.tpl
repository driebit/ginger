"text": {
    "headline": "<a href=\"{{ id.page_url }}\">{{ id.short_title|default:id.title }}</a>",
    "text": "<a href=\"{{ id.page_url }}\">{{ id.summary|default:(id.body|linebreaksbr|striptags|truncate:200 ) }}</a>"
},
