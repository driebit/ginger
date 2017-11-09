(function ($) {
    $.widget("ui.iframe", {
        _init: function () {
            this.allIframes = Array.prototype.slice.call(document.getElementsByTagName("iframe"));
            this.setIframeHeight();
            window.addEventListener("resize", this.setIframeHeight.bind(this));
        },

        setIframeHeight: function () {
            this.allIframes.forEach(function (el) {
                if (el.getAttribute("src").indexOf("gingerembed") !== -1) {
                    el.style.height = el.contentWindow.document.body.scrollHeight + 20 + 'px';
                }
            });
        }
    });
}(jQuery));
