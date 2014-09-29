
{% if reason == "pw" %}
<h2>{_ You entered an unknown username or password.  Please try again. _}</h2>

{% elseif reason == "reminder" %}

<h2>{_ You entered an unknown username or e-mail address.  Please try again. _}</h2>
	
{% elseif reason == "tooshort" %}

<h2>{_ Your new password is too short. _}</h2>

{% elseif reason == "unequal" %}

<h2>{_ The two passwords should be equal. Please retype them. _}</h2>

{% endif %}


{% javascript %}
$("#logon_form form").unmask();
$("#logon_form #username").focus();
{% endjavascript %}
