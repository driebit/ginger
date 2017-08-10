(function ($) {
   'use strict';

    $.widget("ui.search_suggestions", {
        
        model: {
            index: -1,
            suggestions: [],
            input: ''
        },

         update: function(type, value) {
            switch (type) {
                case 'SetSuggestions': {
                    this.model.index = -1;
                    this.model.suggestions = Array.prototype.slice.call(value);
                    this.render();
                }
                break;

                case 'MoveDown': {
                    if (this.model.index === this.model.suggestions.length - 1) {
                        this.model.index = 0;
                    } else {
                        this.model.index = this.model.index + 1;
                        this.model.value = value;
                    }
                    this.render();
                }
                break;

                case 'MoveUp': {
                    if (this.model.index === -1) {
                         this.model.index = this.model.suggestions.length - 1;
                    } else {
                        this.model.index = this.model.index - 1;
                        this.model.value = value;
                    }
                    this.render();
                }
                break;

                case 'SetInput': {
                    this.model.input = value;
                }
                break;

                case 'OnReturnPressed': {
                    this._closeSearch();
                    this._navigateToSearchPage();
                }
                break;
            }
        },

        render: function() {
            this._removeHighlight();

            if (this.model.index === -1 || this.model.suggestions.length === 0) {
                return;
            }

            this.model.suggestions[this.model.index].style.textDecoration = 'underline';

            this.element[0].value = this.model.suggestions[this.model.index].textContent.trim();
        },

        _init: function() {
            this.init();
        },

        init: function() {

            var me = this,
                element = me.element,
                timer = null,
                prevVal = null,
                paramResults = element.data('param-results'),
                paramWire = element.data('param-wire'),
                paramToggleButton = '#' + element.data('param-togglebutton'),
                windowHeight = $(window).height();

                me.toggleButton         = $(paramToggleButton),
                me.searchForm           = $(element.closest('form')),
                me.searchInput          = element,
                me.suggestions          = $('#' + paramResults);

            me.suggestions.removeClass('is-scrolable');
            me.suggestions.hide();
            
            var target = document.querySelector('.search-suggestions__suggestions')

            var observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    me.update('SetSuggestions', mutation.target.querySelectorAll('a'));
                });    
            });

            // configuration of the observer:
            var config = { attributes: true, childList: true, characterData: true };
            
            // pass in the target node, as well as the observer options
            observer.observe(target, config);
            

            function doSearch() {

                var val = me.element.val();

                if (val.length == 0) {
                    me.suggestions.hide();
                    return;
                }

                z_event(paramWire, {value: val});

                setTimeout(function(){
                    me.suggestions.show(0, function() {
                        if (me.suggestions.outerHeight() > windowHeight) {
                            me.suggestions.addClass('is-scrollable');
                        }
                    });
                }, 500);

            }

            $(document).on('keyup', function(e) {
                if (e.keyCode === 13) {
                    me.update('OnReturnPressed');
                }
            });

            me.element.on('keyup', function(e) {
                var key = e.keyCode;
                var inputValue = e.currentTarget.value;
                
                if (key === 38) {
                    me.update('MoveUp', inputValue);
                } else if (key === 40) {
                    me.update('MoveDown', inputValue);
                } else {
                    me.update('SetInput', inputValue);
                    doSearch();
                }
            });

            $(document).on('search:close', $.proxy(me._closeSearch, me));
            $(document).on('search:toggle', $.proxy(me._toggleSearch, me));

            if (me.toggleButton != undefined) me.toggleButton.on('click', $.proxy(me._toggleSearch, me));

        },

        _removeHighlight: function() {
            this.model.suggestions.forEach(function(x) {
                x.style.textDecoration = 'none';
            });
        },

        _closeSearch: function(event) {
            var me = this;
            me._toggleSearch(event, true);
        },

        _toggleSearch: function(event, close) {

            var me = this;

            if (me.toggleButton) me.toggleButton.toggleClass('is-active');

            if(close) {
                me.suggestions.hide();
                me.searchForm.removeClass('is-visible');
                if (me.toggleButton) me.toggleButton.removeClass('is-active');
            } else {
                me.searchForm.toggleClass('is-visible');
            }

            me.searchInput.val('');
            me.suggestions.hide();

            if (me.isVisible()) {
                me.searchForm.on('transitionend', function () {
                    me.searchInput.focus();
                });
            }

            $(document).trigger('search:toggled');

            return false;
        },

        isVisible: function() {

            var me = this;

            if (me.suggestions.css('display') == 'block' || me.searchForm.hasClass('is-visible')) {
                return true;
            } else {
                return false;
            }
        }
    });
})(jQuery);
