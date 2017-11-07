{% lib "js/vendor/clipboard.min.js" %}

{% javascript %}
    var clipboard = new Clipboard('.clipboard');

    // Fallback for Safari
    clipboard.on('error', function(e) {
        Array.from(document.getElementsByClassName('clipboard-error')).forEach(function (element) {
            element.innerHTML = "{_ Press Cmd+C or Ctrl+C to copy. _}";
        });

    });
{% endjavascript %}

{% with (m.modules.active.mod_import_anymeta_dispatch)|if:'page':'id' as path %}
<pre id="{{ #embed_code }}" style="white-space: pre-line;">
{{ '<script src="'|escape }}{% url embed_js use_absolute_url z_language=false %}{{ '"></script>'|escape }}{#
    Content negotation on the resource URI (id.uri) works, but not with CORS:
    controller_id will return a 303 response but not accept CORS (OPTIONS)
    requests. Therefore, we have to store a separate URL to controller_rdf,
    which enables CORS for all requests. We do so in data-rdf. #}
{{ ('<ginger-embed theme="red">

    <a href="http://' ++ m.site.hostname ++ '/' ++ path ++ '/' ++ id.id ++ '" data-rdf=')|escape }}"{% url rsc_json_ld use_absolute_url z_language=false id=id %}"{{ ('></a>

</ginger-embed>')|escape }}
</pre>
{% endwith %}

<p class="clipboard-error"></p>

<button class="btn btn-default clipboard" data-clipboard-target="#{{ #embed_code }}">
    {_ Copy to clipboard _}
</button>
