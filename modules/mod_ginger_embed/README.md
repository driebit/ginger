mod_ginger_embed
=================

This module includes a simple embedding widget. Some JavaScript (`embed.js`)
iterates over all `<ginger-embed>` tags on the HTML page and replaces them
with a widget. The data is retrieved from the RDF endpoint (`controller_rdf`).

To show the embed code on a resource page:

```dtl
{% include "embed/embed.tpl" %}
```

Or supply a different resource id:

```dtl
{% include "embed/embed.tpl" id=123 %}
```

Third-party websites (Ginger and non-Ginger alike) can include the output of
that template to show the widget.

### Embed assets

The module ships with a CSS file in `lib/css/build/embed.css`. You can override
this CSS by adding a file in your own module or site at the same path. If you 
want to change the asset path, you can override the `rdf_embed_css` dispatch 
rule.

If you use Sass, you can include `lib/css/src/embed.scss` instead.