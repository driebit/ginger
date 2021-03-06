(function($) {
    'use strict';

    $.widget("ui.base", {

        _init: function() {
            this.init();
        },

        init: function() {
            var me = this,
                element = me.element;

            //fancybox
            $(".lightbox").fancybox({
                'openEffect': "fade",
                'autoSize': true,
                'autoScale': true,
                'margin': 50,
                'autoCenter': true,
                'autoResize': true,
                'fitToView': true,
                'tpl': {
                        error    : '<p class="fancybox-error"></p>'
                },
                'helpers': {
                    'overlay': {
                        'css': {
                            'background': 'rgba(246, 246, 246, 0.75)'
                        },
                        locked: false
                    },
                    media: {},
                    'title': {
                        type: 'inside'
                    }
                },
                afterShow: function() {

                    var el = $(this.element),
                        fbInner = $(".fancybox-inner");

                    if (el.hasClass('default-video-player')) {
                        var url = el.data('video-url'),
                            height = el.data('video-height'),
                            width = el.data('video-width'),
                            videoHTML = '<video width="' + width +'" height="' + height + '" controls>' +
                              '<source src="' + url + '">' +
                              '</video>';

                        $('.fancybox-inner').hide();
                        $(".fancybox-inner").html(videoHTML);
                        $('.fancybox-inner').show();
                        $.fancybox.update();
                    }
                }
            });

            $(document).on('click', $.proxy(me._documentClick, me));
            $(document).on('touchend', $.proxy(me._documentClick, me));
            $(document).on('keyup', $.proxy(me._documentKeyUp, me));

            // Dirty hack to fix input highlight on ios safari, please remove when ios 11.3 is in use


            // Detect ios 11_x_x affected
            // NEED TO BE UPDATED if new versions are affected
            (function iOS_CaretBug() {

                var ua = navigator.userAgent,
                scrollTopPosition,
                iOS = /iPad|iPhone|iPod/.test(ua),
                iOS11 = /OS 11_0_1|OS 11_0_2|OS 11_0_3|OS 11_1|OS 11_1_1|OS 11_1_2|OS 11_2|OS 11_2_1/.test(ua);

                // ios 11 bug caret position
                if ( iOS && iOS11 ) {

                    $("#zmodal").live('show.bs.modal', function(e) {
                        // Get scroll position before moving top
                        scrollTopPosition = $(document).scrollTop();

                        // Add CSS to body "position: fixed"
                        $("body").css("position", "fixed");
                        $("body").css("width", "100%");
                    });

                    $("zmodal").live('hide.bs.modal', function(e) {

                        $("body").css("position", "static");

                        //Go back to initial position in document
                        $(document).scrollTop(scrollTopPosition);

                    });

                }
            })();
        },

        _documentClick: function(event) {

            var me = this;

            if (!$(event.target).closest('form[role="search"]').length) {

                var searchWidgets = $(':ui-search_suggestions'),
                    isOpen = false;

                $.each(searchWidgets, function(i, widget) {

                    var inst = $(widget).data('ui-search_suggestions');
                    if (inst && inst.isVisible()) {
                        isOpen = true;
                    }
                });

                if (isOpen) {
                    $(document).trigger('search:close');
                }
            }

        },

        _documentKeyUp: function(event) {

            if (event.keyCode == 27) {
                $(document).trigger('search:close');
                $(document).trigger('menu:close');
            }
        }


    });
})(jQuery);
