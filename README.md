# mod_ginger_auth

This [Ginger](https://ginger.nl) module provides the following.

1. Configurable post-logon actions.
2. A tabbed dialog that allows switching between login, signup and forgot
   password.
3. Default authentication settings (in [mod_ginger_auth.erl](mod_ginger_auth.erl)).

## Login/profile nav template

Include [_nav_logon_tpl](_nav_logon.tpl) in your nav bar template, and
optionally show the user’s picture and prefix the user’s name with greeting.

## Link template

Display a link that opens an authentication dialog:

```dtl
{% include "_auth_link.tpl" %}
```

Open dialog at sign up tab:

```dtl
{% include "_auth_link.tpl" tab="signup" %}
```
