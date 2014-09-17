<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-register">
{%
	wire id="register_dialog"
	type="submit"
	postback={ginger_register action=action}
	delegate="ginger_logon"
%}

<div id="logon_error">
{% include "_logon_error.tpl" reason=error_reason %}
</div>

<div id="register_form">
    <iframe src="/lib/images/spinner.gif" id="logonTarget" name="logonTarget" style="display:none"></iframe>
    {% with m.rsc[id].uri as page %}

	{% wire id="signup_form" type="submit" postback={signup} %}
    <form id="signup_form" class="setcookie" method="post" action="postback">
        
        <input type="hidden" name="page" value="{{ page }}" />

		<div id="signup_name_full">
			<label for="name_full">{_ Your name _}</label>
            <input class="form-control" id="name_full" name="name_full" type="text" value="{{ name_first|escape }}" />
            {% validate id="name_full" type={presence} %}
		</div>

		<div id="signup_email">
			<label for="email">{_ E-mail _}</label>
			{% if email %}
				<span>{{ email|escape }}</span>
			{% else %}
				<input class="form-control" id="email" name="email" type="text" value="{{ email|escape }}" />
				{% validate id="email" type={email} type={presence} %}
			{% endif %}
		</div>

        {#
        <div id="signup_username">
            <label for="username">{_ Username _}</label>
            <input class="form-control" id="username" name="username" type="text" value="" />
            {% validate id="username" wait=400 type={presence} type={username_unique} %}
        </div>
        #}

        <div id="signup_password1">
            <label for="password1">{_ Password _}</label>
            <input class="form-control" id="password1" name="password1" type="password" value="" autocomplete="off" />
            {% validate id="password1" 
                type={presence} 
                type={length minimum=6 too_short_message="Too short, use 6 or more."} %}
        </div>

        {#
        <div id="signup_password2">
            <label for="password2">{_ Verify password _}</label>
            <input class="form-control" id="password2" name="password2" type="password" value="" autocomplete="off" />
            {% validate id="password2" 
                type={presence} 
                type={confirmation match="password1"} %}
        </div>
        #}

		<p class="clear"></p>

        <div class="form-group" id="signup_button">
            <div>
                <button class="btn btn-primary btn-lg pull-right" type="submit">{_ Register _}</button>
            </div>
        </div>

    </form>
    {% endwith %}
</div>    

<ul id="logon_methods">
    {% all include "_logon_extra.tpl" %}
</ul>

{# <a data-toggle="tab" href="#{{ #tab }}-logon"><i class="glyphicon glyphicon-log-in">&nbsp;</i>{_ I have an account, Log me in. _}</a> #}

</div>

{# Use a real post for all forms on this page, and not AJAX or Websockets. This will enforce all cookies to be set correctly. #}
{% javascript %}
z_only_post_forms = true;
{% endjavascript %}

