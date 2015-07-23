
$.widget( "ui.global_nav", {

    options: {
    },

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

         me.document         = $(document),
         me.body             = $('body:eq(0)'),

        me.searchButton     = $(widgetElement.find('.global-nav__actions__toggle-search')[0]),
        me.searchForm       = $(widgetElement.find('.global-nav__actions__search')[0]),
        me.searchInput      = $(widgetElement.find('.do_search')[0]);
        me.mainMenuContainer = $(widgetElement.find('')[0]),
        me.menuButton       = $(widgetElement.find('.global-nav__actions__toggle-menu')[0]),

        me.searchButton.on('click', $.proxy(me._toggleSearch, me));
        me.document.on('click', $.proxy(me._documentClick, me));
        me.menuButton.on('click', $.proxy(me._toggleMenu, me));
    },

    _toggleSearch: function() {

        var me = this;

        me.searchButton.toggleClass('is-active');

         if(me.searchButton.hasClass('is-active')) {
            me.searchForm.toggleClass('is-visible');
         } else {
            me.searchForm.toggleClass('is-visible');
            me.searchInput.val('');
         }

         setTimeout(function(){
            me.searchInput.focus();
         }, 500);

         return false;
    },

    _toggleMenu: function() {

        var me = this;

        me.menuButton.toggleClass('is-active');

        if(me.menuButton.hasClass('is-active')) {
            me.mainMenuContainer.removeClass('hidden');
        } else {
            me.mainMenuContainer.addClass('hidden');
        }

        return false;

    },
});

