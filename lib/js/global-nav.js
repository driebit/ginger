
$.widget( "ui.global_nav", {

    options: {
    },

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.document            = $(document),
        me.body                = $('body:eq(0)'),

        me.searchButton         = $(widgetElement.find('#toggle-search')[0]),
        // me.searchForm           = $(widgetElement.find('form[role=search]')[0]),
        // me.searchInput          = $(widgetElement.find('.do_search')[0]);
        // me.mainMenuContainer    = $(me.element),
        me.menuButton           = $(widgetElement.find('#toggle-menu')[0]);

        me.searchButton.on('click', $.proxy(me._toggleSearch, me));
        me.menuButton.on('click', $.proxy(me._toggleMenu, me));

    },

    _toggleSearch: function() {
        $(document).trigger('search:toggle');
    },

    _toggleMenu: function() {

        var me = this;

        me.menuButton.toggleClass('is-active');

        if(me.menuButton.hasClass('is-active')) {
            me.mainMenuContainer.addClass('is-open');
        } else {
            me.mainMenuContainer.removeClass('is-open');
        }

        return false;

    },
});

