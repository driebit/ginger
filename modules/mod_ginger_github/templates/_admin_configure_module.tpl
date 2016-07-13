<div class="modal-body">
    <div class="form-group">
        <label class="control-label" for="oauth_token">{_ Github OAuth2 token _}</label>
        <div>
            <input type="text" id="oauth_token" name="oauth_token"
                   value="{{ m.config.mod_ginger_github.oauth_token.value|escape }}"
                   class="do_autofocus col-lg-4 col-md-4 form-control"/>
            {% wire id="oauth_token" type="blur" action={config_toggle module="mod_ginger_github" key="oauth_token" on="keyup"} %}
        </div>
        <p class="info-block">{_ You can generate a GitHub API token at <a href="https://github.com/settings/tokens">https://github.com/settings/tokens</a>. _}</p>

        <label class="control-label" for="zenhub_token">{_ ZenHub token _}</label>
        <div>
            <input type="text" id="zenhub_token" name="zenhub_token"
                   value="{{ m.config.mod_ginger_github.zenhub_token.value|escape }}"
                   class="do_autofocus col-lg-4 col-md-4 form-control"/>
            {% wire id="zenhub_token" type="blur" action={config_toggle module="mod_ginger_github" key="zenhub_token" on="keyup"} %}
        </div>
        <p class="info-block">{_ If you use <a href="https://www.zenhub.com/">ZenHub</a>, paste your <a href="https://github.com/ZenHubIO/API">API token</a> here _}.</p>
    </div>
</div>

<div class="modal-footer">
    {% button class="btn btn-default" text=_"Close" action={dialog_close} tag="a" %}
</div>

