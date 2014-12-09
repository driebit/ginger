<div class="tab-pane {% if is_active %}active{% endif %}" id="{{ tab }}-signup">
{%
	wire id="signup_dialog"
	type="submit"
	postback={ginger_signup action=action}
	delegate="ginger_logon"
%}

<div id="signup_error" style="display:none">
    {% include "_signup_error.tpl" reason=error_reason %}
</div>

<div id="signup_form">
    <form id="signup_dialog" class="setcookie" method="post" action="postback">
        
		<div id="signup_name_full"class="form-group">
			<label for="name_full" class="control-label">{_ Your name _}</label>
            <div class="controls">
                <input class="form-control" id="name_full" name="name_full" type="text" value="{{ name_full|escape }}" style="width: 250px" />
                {% validate id="name_full" type={presence} %}
            </div>
		</div>

		<div id="signup_email"class="form-group">
			<label for="email" class="control-label">{_ E-mail _}</label>

            <div class="controls">
    			{% if email %}
    				<span>{{ email|escape }}</span>
    			{% else %}
    				<input class="form-control" id="email" name="email" type="text" value="{{ email|escape }}" />
    				{% validate id="email" type={presence} type={email failure_message=_"A valid email addres"} %}
    			{% endif %}
            </div>
		</div>

        <div id="signup_password"class="form-group">
            <label for="password1" class="control-label">{_ Password _}</label>

            <div class="controls">
                <input class="form-control" id="password1" name="password1" type="password" value="" autocomplete="off" />
                {% validate id="password1" name="password1" type={presence} type={length minimum=6 too_short_message=_"6 characters or more."} %}
            </div>
        </div>

        <div class="form-group clearfix" id="signup_button">
            <div>
                <button class="btn btn-primary btn-lg pull-right" type="submit">{_ Signup _}</button>
            </div>
        </div>

    </form>
</div>    

</div>


