
{% if reason|first == "identity_in_use" %}

    <p style="color: red;">{_ E-mail/password already registered _}</p>
    {% javascript %}
    $("#signup_form form").unmask();
    $("#signup_form #username").focus();
    {% endjavascript %}

{% elseif reason|first == "reminder" %}

    <p style="color: red;">{_ E-mail/User not found _}</p>

{% endif %}


