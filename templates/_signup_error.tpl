
{% if reason|first == "identity_in_use" %}

    <h2>{_ E-mail/password already registered _}</h2>

{% elseif reason|first == "reminder" %}


{% endif %}


{% javascript %}
$("#signup_form form").unmask();
$("#signup_form #username").focus();
{% endjavascript %}
