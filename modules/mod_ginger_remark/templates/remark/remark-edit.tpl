{% with remark_id|temporary_rsc:{props category=`remark`} as the_remark_id %}

    <h4>remark id: {{ the_remark_id }}</h4>
    <h4>id: {{ id }}</h4>
    <h4></h4>
    <div class="remark" id="remark_{{ the_remark_id }}">
        <form id="rscform" method="post" action="postback" class="remark-form" data-tinyname="rsc-tiny{{#ident}}">
            <input type="hidden" name="id" value="{{ the_remark_id }}" />

            <input type="hidden" name="object|about" value="{{ id }}" />
            <input type="hidden" name="object|author" value="{{ m.acl.user }}" />
            <input type="hidden" name="rights" value="CR" />
            <input type="hidden" name="is_published" value="true" />

            <fieldset>
                <textarea rows="10" cols="10" id="rsc-aap{{#ident}}" name="body" class="body z_editor-init form-control">{{ remark_id.body }}</textarea>
            </fieldset>

            {% if not is_new %}
                <div class="buttons">
                    <a href="#" class="remark-cancel">cancel</a>
                </div>
            {% endif %}

            <a href="#" class="remark-save">save</a>

        </form>
    </div>

    <hr />

    <br><br>

    {% wire id="rscform" type="submit" postback={rscform} delegate="controller_admin_edit" %}

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
        $(document).trigger('remark:editing', {{ the_remark_id }});
        $(document).trigger('remark:new', {{ the_remark_id }});
    {% endjavascript %}

{% endwith %}
