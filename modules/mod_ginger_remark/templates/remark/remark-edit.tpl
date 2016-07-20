{% with remark_id|temporary_rsc:{props category=`remark`} as the_remark_id %}
    <div class="remark" id="remark_{{ the_remark_id }}">
        <form id="rscform" method="post" action="postback" class="remark-form" data-tinyname="rsc-tiny{{#ident}}">
            <input type="hidden" name="id" value="{{ the_remark_id }}" />

            <input type="hidden" name="object|about" value="{{ id }}" />
            <input type="hidden" name="object|author" value="{{ m.acl.user }}" />
            <input type="hidden" name="rights" value="CR" />
            <input type="hidden" name="is_published" value="true" />
            <input type="hidden" name="content_group_id" value="{{ m.rsc.cg_user_generated.id }}" />

            <fieldset>
                {% if not m.acl.user and is_new %}
                    <div class="remark-form__anonymous">
                        <p class="remark-form__name">
                            <label for="anonymous_name">{_ Name _}</label><input type="text" name="anonymous_name" id="anonymous_name" value="{{ remark_id.anonymous_name }}">
                        </p>
                        <p class="remark-form__email">
                            <label for="anonymous_email">{_ E-mail _}</label><input type="text" name="anonymous_email" id="anonymous_email" value="{{ remark_id.anonymous_email }}">
                            <small><label for="anonymous_email_visible"><input type="checkbox" name="anonymous_email_visible" id="anonymous_email_visible">{_ visible for public _}</label></small>
                        </p>
                    </div>
                {% endif %}
                <p>
                    <label for="title">{_ Title _}</label><input type="text" name="title" id="title" value="{{ remark_id.title }}">
                </p>

                <textarea rows="10" cols="10" id="rsc-tiny{{#ident}}" name="body" class="body z_editor-init form-control">{{ remark_id.body }}</textarea>
            </fieldset>

            <div class="remark-form__buttons">
                {% if not is_new %}
                    <button class="remark-cancel btn--secondary" title="{_ cancel _}">{_ cancel _}</button>
                {% endif %}
                <button class="remark-save btn--primary" title="{_ save _}">{_ save _}</button>
            </div>

        </form>
    </div>

    {% wire id="rscform" type="submit" postback={rscform on_success={script script="$(document).trigger('remark:saved', " ++ the_remark_id ++ ");" }} delegate="mod_ginger_edit" %}

    {% wire name="zmedia"
    action={
        dialog_open
        template="_action_dialog_connect.tpl"
        title=_"Insert image"
        subject_id=the_remark_id
        predicate=`depiction`
        tab="upload"
        tabs_enabled=["upload","oembed"]
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
        {% if is_new == 1 %}$(document).trigger('remark:new', {{ the_remark_id }}); {% endif %}
    {% endjavascript %}

{% endwith %}
