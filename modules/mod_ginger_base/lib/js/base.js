$.widget("ui.base", {

    _init: function() {
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

        this._addEventListeners();
    },

    _addEventListeners: function() {
        $(document).on('keyup', this._documentKeyUp.bind(this));
    },

    _documentKeyUp: function(event) {
        if (event.keyCode == 27) {
            $(document).trigger('menu:close');
        }
    }
});
