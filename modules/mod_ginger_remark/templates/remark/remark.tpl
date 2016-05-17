
{% with remark_id|temporary_rsc:{props category=`article`} as id %}


    {% wire name="zmedia"
    action={
        dialog_open
        template="_action_dialog_connect.tpl"
        title=_"Insert image"
        subject_id=id
        predicate=`depiction`
        is_zmedia
        tab="depiction"
        callback="window.zAdminMediaDone"
        center=0
    }
    %}

    {% wire name="zlink"
    action={
        dialog_open
        template="_action_dialog_connect.tpl"
        title=_"Add link"
        subject_id=id
        is_zlink
        tab="find"
        callback="window.zAdminLinkDone"
        center=0
    } %}

    {% javascript %}

        setTimeout(function() {
            z_editor.init();
        }, 1000);

    {% endjavascript %}


<h4>id: {{ id }}</h4>
<h4></h4>

<form id="rscform" method="post" action="postback" class="remark-form do_remark_widget" data-attr-remark-id="{{ the_remark_id }}" data-tinyname="rsc-aap{{#ident}}">
    <input type="hidden" name="id" value="{{ id }}" />
    <fieldset>
        <textarea rows="10" cols="10" id="rsc-aap{{#ident}}" name="body" class="body z_editor-init form-control">aap <b>stukje bold</b></textarea>
    </fieldset>

    <div class="buttons"><a href="#" class="remark-edit">edit</a>
        <a href="#" class="testsave">save</a>
    </div>
</form>

{% endwith %}
