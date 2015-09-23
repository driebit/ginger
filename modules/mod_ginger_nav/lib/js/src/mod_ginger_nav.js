
$.widget( "ui.mod_ginger_nav", {

    options: {
    },

    _create: function() {

        var me = this,
            widgetElement = $(me.element);

        me.document         = $(document),
        me.body             = $('body:eq(0)'),
        me.overlay          = $('.overlay'),
        me.searchButton     = $(widgetElement.find('.mod_ginger_nav__main-nav__search-button:eq(0)')[0]),
        me.searchForm       = $(widgetElement.find('.ginger-search')[0]),
        me.searchInput      = $(widgetElement.find('.ginger-search_form-control')[0]),
        me.mainMenuContainer = $(widgetElement.find('.mod_ginger_nav__main-nav__container')[0]),
        me.mainMenu         = $(widgetElement.find('.mod_ginger_nav__main-nav__container__menu')[0]),
        me.menuButton       = $(widgetElement.find('.mod_ginger_nav__main-nav__toggle-menu')[0]),
        me.themeBanner      = $(widgetElement.find('.mod_ginger_nav__theme-banner')[0]),
       
        //listeners
        me.searchButton.on('click', $.proxy(me._toggleSearch, me));
        me.document.on('click', $.proxy(me._documentClick, me));
        me.menuButton.on('click', $.proxy(me._toggleMenu, me));
        me.overlay.on('click', $.proxy(me._toggleMenu, me));
        me.themeBanner.on('click', $.proxy(me._scrollToTop, me));

        //init
        if(me.themeBanner.size() > 0) {
            me.body.addClass('has-theme');
        }
        

    },

    _documentClick: function(event) {

        var me = this;
        
        if (!$(event.target).closest('.mod_ginger_nav__main-nav').length) {
           if (me.searchForm.hasClass('is-visible')) {
               me._toggleSearch();
           }
        }
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

    },

    _toggleMenu: function() {

        var me = this;

        me.menuButton.toggleClass('is-active');

        if(me.menuButton.hasClass('is-active')) {
            me.mainMenuContainer.removeClass('hidden');
        } else {
            me.mainMenuContainer.addClass('hidden');
        }

    },

    _scrollToTop: function() {
        $("html, body").animate({ scrollTop: 0 }, "slow");
        return false;
    }

});

