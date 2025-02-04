{#
This template maintains the newest tinymce version.

params:
overrides_tpl: (optional) template location that contains JavaScript overrides for tinymce init
#}

{% wire name="zmedia"
    action={
        dialog_open
        template="_action_ginger_dialog_connect.tpl"
        title=_"Insert image"
        subject_id=id
        predicate=`depiction`
        is_zmedia
        tab="upload"|default:"depiction"
        tabs_enabled=["upload"]
        callback="window.zAdminMediaDone"
        center=0
        autoclose
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
        tabs_enabled=(zotonic_dispatch=="ginger_edit")|if:["find"]:["find", "upload"]
        callback="window.zAdminLinkDone"
        center=0
        autoclose
    }
%}

{% with
    "4.9.6",
    m.config.mod_editor_tinymce.version.value
    as
    newest,
    config
%}
{% with
    (config == "newest" or config|is_undefined)|if:newest:config
    as
    version
%}
{% include
    "tinymce-" ++ version ++ "/_editor.tpl"
    overrides_tpl=overrides_tpl|default:"_admin_tinymce_overrides_js.tpl"
    is_editor_include=is_editor_include
    id=id
%}
{% endwith %}
{% endwith %}
