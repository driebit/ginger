# mod_ginger_banner

This [Ginger](https://ginger.nl) module provides the following.

1. Configurable banner through config key
2. Configurable banner for editors through resource

## How to add a banner for admins

Add your banner message in your site’s `config` file:

```erlang
{mod_ginger_banner, [{message, "The website will be updated between 00:00 - 02:00, some errors may occur"}]}
```

## How to add a banner for editors

Add your banner by publishing the `message_banner` resource. The body text will 
appear on the banner.
