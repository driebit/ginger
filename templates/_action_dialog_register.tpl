<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-register">
{%
	wire id="signup_dialog"
	type="submit"
	postback={ginger_handle_signup action=action}
	delegate="ginger_logon"
%}

<div id="logon_error">
{% include "_logon_error.tpl" reason=error_reason %}
</div>

<div id="register_form">
    <form id="signup_dialog" class="setcookie" method="post" action="postback">
        
		<div id="signup_name_full"class="form-group">
			<label for="name_full" class="control-label">{_ Your name _}</label>
            <input class="form-control controls" id="name_full" name="name_full" type="text" value="{{ name_first|escape }}" />
            {% validate id="name_full" type={presence} %}
		</div>

		<div id="signup_email"class="form-group">
			<label for="email" class="control-label">{_ E-mail _}</label>
			{% if email %}
				<span>{{ email|escape }}</span>
			{% else %}
				<input class="form-control controls" id="email" name="email" type="text" value="{{ email|escape }}" />
				{% validate id="email" type={email} type={presence} %}
			{% endif %}
		</div>

        {#
        <div id="signup_username"class="form-group">
            <label for="username" class="control-label">{_ Username _}</label>
            <input class="form-control controls" id="username" name="username" type="text" value="" />
            {% validate id="username" wait=400 type={presence} type={username_unique} %}
        </div>
        #}

        <div id="signup_password1"class="form-group">
            <label for="password1" class="control-label">{_ Password _}</label>
            <input class="form-control controls" id="password1" name="password1" type="password" value="" autocomplete="off" />
            {% validate id="password1" 
                type={presence} 
                type={length minimum=6 too_short_message="Too short, use 6 or more."} %}
        </div>

        {#
        <div id="signup_password2"class="form-group">
            <label for="password2" class="control-label">{_ Verify password _}</label>
            <input class="form-control controls" id="password2" name="password2" type="password" value="" autocomplete="off" />
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

