mod_ginger_embed
=================

This module allows Ginger and non-Ginger sites to embed Ginger resources by use of an `<iframe>`.

## Embed assets

The module ships with a SCSS file in `lib/css/src/embed.scss`. This file includes your site's color and typography variables, and you're expected to write the output to your site's `lib/css/site` directory as `embed.css`.

## Embedding sites in Ginger
Due to the sanitizing of input-fields in Ginger, sites have to be whitelisted in order to be embedded via the media-item interface. This can be done with the following config.


```erlang
ginger_config:install_config(
    [{ mod_ginger_embed, allowed_hosts, <<"www.example.com, www.exampla.net">>}]
    Context
)
```
