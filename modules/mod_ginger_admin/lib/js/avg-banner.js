(function ($) {

    $.widget("ui.avg", {
        _init: function() {
            this.init();
        },

        init: function() {
            // Set hasAvgCookie
            this._getCookies();

            if (!this.hasAvgCookie) {
                this.element.addClass('-show');
            }

            $('.avg-banner__close').on('click', function() {
                this._closeAvg();
            }.bind(this));
        },

        _closeAvg: function(event) {
            var cookieDate = new Date;

            this.element.removeClass('-show');
            this.element.addClass('-remove');

			cookieDate.setFullYear(cookieDate.getFullYear() + 1);

            document.cookie = 'ginger_avg=1; expires=' + cookieDate.toGMTString( ) + ';';

            this._getCookies();
        },

        _getCookies: function() {
            this.cookies = document.cookie.split(';').map(function(x) {
                return x.trim()
            });

            this.hasAvgCookie = this._member("ginger_avg=1", this.cookies);
        },

        _member(x, arr) {
            return arr.indexOf(x) !== -1;
        }
    });

})(jQuery);
