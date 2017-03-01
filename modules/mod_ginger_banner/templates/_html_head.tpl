{% lib
    "css/banner.css"
%}
{% javascript %}

    {% if m.config.mod_ginger_banner.message or (m.rsc.message_banner.is_published and m.rsc.message_banner.body) %}
        $('document').ready(function(){
            $('<div class="ginger-banner">{% if m.config.mod_ginger_banner.message.value %}{{ m.config.mod_ginger_banner.message.value|escapejs }}{% else %}{{ m.rsc.message_banner.body|escapejs }}{% endif %}</div>').appendTo($('body'));
        })
    {% endif %}
{% endjavascript %}
