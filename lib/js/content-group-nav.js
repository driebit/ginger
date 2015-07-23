
$.widget( "ui.content_group_nav", {

    options: {
    },

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.body = $('body:eq(0)');
        me.banner = $(widgetElement.find('.content-group-nav__banner')[0]);  

        me.banner.on('click', $.proxy(me._scrollToTop, me));

        $(window).scroll($.proxy(me._scrolled, me));

        if(me.banner.size() > 0) {
            me.body.addClass('has-content-group');
        }

    },

    _scrollToTop: function() {
        $("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    },

    _scrolled: function(event) {
        
        var me = this,
            scrollTop = $(window).scrollTop(),
            minPoint = 100,
            isMinified = $(this.banner).hasClass('is-minified');

        if (scrollTop > minPoint) {
            if(!isMinified) me.banner.addClass('is-minified');
        } else {
            me.banner.removeClass('is-minified');
        }
    }

});

