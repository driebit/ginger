{% lib "js/vendor/clipboard.min.js" %}

{% javascript %}
    new Clipboard('.clipboard');
{% endjavascript %}

<pre id="{{ #embed_code }}">
{{ '<script src="'|escape }}{% url rdf_embed_js use_absolute_url z_language=false %}{{ '"></script>'|escape }}{#
    Content negotation on the resource URI (id.uri) works, but not with CORS:
    controller_id will return a 303 response but not accept CORS (OPTIONS)
    requests. Therefore, we have to store a separate URL to controller_rdf,
    which enables CORS for all requests. We do so in data-rdf. #}
{{ '<link href="'|escape }}{% url rdf_embed_css use_absolute_url z_language=false %}{{ ('" type="text/css" media="all" rel="stylesheet">
<ginger-embed>
    <a href="' ++ id.uri ++ '" data-rdf=')|escape }}"{% url rsc_json_ld use_absolute_url z_language=false id=id %}"{{ ('></a>
</ginger-embed>')|escape }}
</pre>

<button class="btn btn-default clipboard" data-clipboard-target="#{{ #embed_code }}">
    {_ Copy to clipboard _}
</button>
