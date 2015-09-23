{# Ginger-preferred config for signup modal

logon_state
logon_context
update_target
update_template
style_boxed
style_width
#}

{# non-critical values, may be changed #}
{% with
    1,
    0,
    0,
    0,
    0,
    0, 
    style_boxed|if_undefined:0,
    style_width|if_undefined:"100%"
as  
    show_signup_name_title,
    show_signup_name_prefix,
    show_signup_username_title,
    show_signup_password2,
    show_signup_tos_title,
    show_signup_tos_info,
    style_boxed,
    style_width
%}
    {% include "_signup.tpl" %}
{% endwith %}
