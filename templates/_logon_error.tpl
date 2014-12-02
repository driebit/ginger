
{% if reason == "pw" %}
    <p style="color: red;">{_ You entered an unknown username or password.  Please try again. _}</p>
{% elseif reason == "user_not_enabled" %}
    <p style="color: red;">{_ You have to confirm your account first.  Please see the email send to you. _}</p>
{% elseif reason == "reminder" %}
    <p style="color: red;">{_ You entered an unknown username or e-mail address.  Please try again. _}</p>
{% elseif reason == "tooshort" %}
    <p style="color: red;">{_ Your new password is too short. _}</p>
{% elseif reason == "unequal" %}
    <p style="color: red;">{_ The two passwords should be equal. Please retype them. _}</p>
{% endif %}


{% javascript %}
$("#logon_form form").unmask();
$("#logon_form #username").focus();
{% endjavascript %}
