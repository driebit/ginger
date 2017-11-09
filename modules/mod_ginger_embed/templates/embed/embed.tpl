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

<textarea id="{{ #embed_code }}" style="width: 100%; padding: 3px 8px;"><iframe src="http://{{ m.site.hostname }}/gingerembed/{{ id.id }}"></iframe></textarea>

<p class="clipboard-error"></p>

<button class="btn btn-default clipboard" data-clipboard-target="#{{ #embed_code }}">
    {_ Copy to clipboard _}
</button>
