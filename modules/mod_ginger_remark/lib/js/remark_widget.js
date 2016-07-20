(function ($) {
   'use strict';

    $.widget( "ui.remark_widget", {
        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                widgetElement = $(me.element);

                me.widgetElement = widgetElement;

                widgetElement.on('click', '.remark-cancel', function() {
                    var editing = me.widgetElement.data('editing');
                    $.proxy(me.switchToView(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-edit', function() {
                    var editing = me.widgetElement.data('editing');
                    $.proxy(me.switchToEdit(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-save', function() {
                    $.proxy(me.save(), me);
                    return false;
                });

                widgetElement.on('click', '.remark-delete', function() {
                    var remark_id = me.widgetElement.data('remarkid');

                    $.proxy(me.delete(remark_id), me);
                    return false;
                });

                widgetElement.on('click', '.depiction-delete', function() {
                    var depiction_id = $(this).data('id');

                    $.proxy(me.delete(depiction_id), me);

                    return false;
                });

        },

        switchToEdit: function() {

            var me = this,
                remark_id = me.widgetElement.data('remarkid'),
                id = me.widgetElement.data('id'),
                unique = me.widgetElement.data('unique');

            me.widgetElement.data('editing', 1);

            z_event('render_remark_'+unique, {'editing':1, 'remark_id': remark_id, 'id': id});

            return false;

        },

        switchToView: function() {

            var me = this,
                remark_id = me.widgetElement.data('remarkid'),
                id = me.widgetElement.data('id'),
                unique = me.widgetElement.data('unique');

            me.widgetElement.data('editing', '0');

            z_event('render_remark_' + unique, {'editing':0, 'remark_id': remark_id, 'id': id });

            return false;

        },

        setValues: function(remark_id) {

            var me = this;

            if (remark_id) {
                me.widgetElement.data('remarkid', remark_id);
            }

        },

        save: function() {

            var me = this,
                form = me.widgetElement.find('#rscform'),
                tinyname = form.data('tinyname'),
                contentText = tinymce.get(tinyname).getContent({'format':'text'}).trim(),
                anonymousName = $('#anonymous_name'),
                anonymousEmail = $('#anonymous_email'),
                title = $('input#title'),
                valid = true,
                re = /[a-z A-Z 0-1]+/i,
                em = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

            var rawContent = tinymce.get(tinyname).getContent({'format':'raw'});

            rawContent = rawContent.replace(/<img([^>])*>/gi, 'img').trim();
            rawContent = $(rawContent).text();

            $('.mce-tinymce').removeClass('is-error');
            title.closest('p').removeClass('is-error');

            if (!rawContent || rawContent == "") {
                $('.mce-tinymce').addClass('is-error');
                valid = false;
            }

            if (!re.test(title.val())) {
                title.closest('p').addClass('is-error');
                valid = false;
            }

            if (anonymousName.size() > 0) {
                if (!re.test(anonymousName.val())) {
                    anonymousName.closest('p').addClass('is-error');
                    valid = false;
                }

                if (!em.test(anonymousEmail.val())) {
                    anonymousEmail.closest('p').addClass('is-error');
                    valid = false;
                }
            }

            if (valid) {
                $('.remark-save').hide();
                $('.remark-cancel').hide();
                $(form).submit();
                return false;
            }

            return false;
        },

        afterSave: function() {

            var me = this;
            me.switchToView();
        },

        delete: function(id) {

            var me = this;

            z_event('rsc_delete_' + id);
        },

        afterDelete: function() {

            var me = this;

            delete z_registered_events['rsc_delete_' + me.widgetElement.data('remarkid')];
            delete z_registered_events['render_remark_' + me.widgetElement.data('unique')];

            if (me.widgetElement) me.widgetElement.remove();

        },

        afterDepictionDelete: function() {

            var me = this;

            me.switchToView();

        }

    });
})(jQuery);
