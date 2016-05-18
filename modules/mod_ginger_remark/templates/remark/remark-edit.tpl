{% with remark_id|temporary_rsc:{props category=`article`} as the_remark_id %}

    {% wire name="zmedia"
    action={
        dialog_open
        template="_action_dialog_connect.tpl"
        title=_"Insert image"
        subject_id=the_remark_id
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
        subject_id=the_remark_id
        is_zlink
        tab="find"
        callback="window.zAdminLinkDone"
        center=0
    } %}

    {% javascript %}
        z_editor.init();
        $(document).trigger('remark:editing');
    {% endjavascript %}


<h4>id: {{ the_remark_id }}</h4>
<div class="remark" id="remark_{{ the_remark_id }}">
    <form id="rscform" method="post" action="postback" class="remark-form" data-attr-remark-id="{{ the_remark_id }}" data-tinyname="rsc-aap{{#ident}}">

        <input type="hidden" name="id" value="{{ the_remark_id }}" />
        <input type="hidden" name="object|author" value="{{ m.acl.user }}" />

        <fieldset>
            <p>
                <label for="title">Titel</label><input type="text" name="title" id="title">
            </p>
            <textarea rows="10" cols="10" id="rsc-aap{{#ident}}" name="body" class="body z_editor-init form-control">aap <b>stukje bold</b></textarea>
        </fieldset>

        <div class="remark-form__buttons">
            <button class="remark-edit btn--secondary">cancel</button>

            <button class="remark-save btn--primary">save</button>
        </div>
    </form>
</div>

{% wire id="rscform" type="submit" postback={rscform view_location=[]} delegate="controller_admin_edit" %}

{% endwith %}
