{# Original template: admin_js_include.tpl #}
{#
    Overwrite needed because in original template there is an all include
    that includes _editor.tpl again. Where we only want to include
    _ginger-editor.tpl.
#}

{% lib
    "bootstrap/js/bootstrap.min.js"
%}

{% lib
    "js/apps/zotonic-1.0.js"
    "js/apps/z.widgetmanager.js"

    "js/modules/ubf.js"
    "js/qlobber.js"
    "js/pubzub.js"

    "js/modules/jquery.hotkeys.js"

    "js/apps/admin-common.js"

    "js/jquery.ui.nestedSortable.js"

    "js/modules/z.adminwidget.js"

    "js/modules/z.live.js"
    "js/modules/z.notice.js"
    "js/modules/z.tooltip.js"
    "js/modules/z.dialog.js"
    "js/modules/z.feedback.js"
    "js/modules/z.formreplace.js"
    "js/modules/z.datepicker.js"
    "js/modules/z.menuedit.js"
    "js/modules/z.cropcenter.js"
    "js/modules/z.popupwindow.js"
    "js/modules/livevalidation-1.3.js"
    "js/modules/jquery.loadmask.js"
    "js/modules/jquery.timepicker.min.js"
    "js/modules/jstz.min.js"

    "js/ginger_edit.js"
%}

{% if m.modules.active.mod_geo %}
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key={{ m.config.mod_geo.api_key.value|escape }}"></script>
    {% lib "js/admin-geo.js" %}
{% endif %}

{% if m.modules.active.mod_geomap %}
    {% include "_js_geomap.tpl" %}
{% endif %}

{% if m.modules.active.mod_admin_multiupload and m.acl.is_allowed.use.mod_admin_multiupload %}
    {% lib "js/jquery.fileupload.js" %}
{% endif %}
<script type="text/javascript">
$(function()
{
    $.widgetManager();
});
</script>
