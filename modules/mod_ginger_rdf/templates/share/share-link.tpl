<li>
    <a id="{{ #embed }}" href=""" title="{_ Embed _}" class="">{_ Embed _}</a>
    {% wire id=#embed action={dialog_open title=_"Embed" template="rdf/embed-dialog.tpl" id=id } %}
</li>
