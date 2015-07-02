# mod_ginger_auth

This [Ginger](ttps://ginger.nl) module provides the following.

1. Default authentication settings (in [mod_ginger_auth.erl](mod_ginger_auth.erl)).
2. A tabbed dialog that allows switching between login, signup and forgot
   password.

## Link template

Display a link that open an authentication dialog:

```dtl
{% include "_auth_link.tpl" %}
```

Open default sign up tab by default:

```dtl
{% include "_auth_link.tpl" tab="signup" %}
```
