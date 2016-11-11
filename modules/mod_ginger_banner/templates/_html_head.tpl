{% lib
    "css/banner.css"
%}
{% javascript %}

    {% if m.config.mod_ginger_banner.message or (m.rsc.message_banner.is_published == "true" and m.rsc.message_banner.body) %}
        $('document').ready(function(){
            $('<div class="ginger-banner">{% if m.config.mod_ginger_banner.message.value %}{{ m.config.mod_ginger_banner.message.value }}{% else %}{% if m.rsc.message_banner %}{{ m.rsc.message_banner.body }}{% endif %}{% endif %}</div>').appendTo($('body'));
        })
    {% endif %}
{% endjavascript %}
