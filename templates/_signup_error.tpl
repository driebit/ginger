
{% if reason == "identity_in_use" %}

    <h4 style="color: red;">{_ E-mail/password already registered _}</h4>
    {% javascript %}
    $("#signup_form form").unmask();
    $("#signup_form #username").focus();
    {% endjavascript %}

{% elseif reason == "reminder" %}

    <h4 style="color: red;">{_ E-mail/User not found _}</h4>

{% endif %}


