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
                }
                break;

                /*
                 * Tab should always move focus out of the search form.
                 * If there are no search suggestions, only blur will be triggered (no keyup for tab)
                 * If there are search suggestions, OnBlur will not move focus because the focus moved inside of the search form, so we move it after `_closeSearch`
                 * If the user navigates to a search suggestion with the arrow keys, only blur will be triggered and we should not do anything
                 */
                case 'OnBlur': {
                    const event = value;

                    // Check that the new focus is outside of the search form
                    if(event.relatedTarget && $(event.relatedTarget).parents('.search-suggestions__searchform').length === 0){
                        this._closeSearch();

                        const relativePosition = event.target.compareDocumentPosition(event.relatedTarget)
                        if (relativePosition & Node.DOCUMENT_POSITION_FOLLOWING){
                            $('#toggle-search').next().focus();
                        } else if (relativePosition & Node.DOCUMENT_POSITION_PRECEDING) {
                            $('#toggle-search').prev().focus();
                        }
                    }
                }
                break;

                case 'OnTab': {
                    const event = value;

                    this._closeSearch();

                    if (event.shiftkey){
                        $('#toggle-search').prev().focus();
                    } else {
                        $('#toggle-search').next().focus();
                    }
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
            this.model.suggestions[this.model.index].style.fontWeight = '800';

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
            me.searchInput.prop('disabled', true);

            var observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    me.update('SetSuggestions', mutation.target.querySelectorAll('a'));
                });
            });

            // configuration of the observer:
            var config = { attributes: true, childList: true, characterData: true };

            // pass in the target node, as well as the observer options
            observer.observe(me.suggestions[0], config);


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

            me.element.on('blur', function(e) {
                me.update('OnBlur', e);
            })

            me.element.on('keyup', function(e) {
                var key = e.keyCode;
                var inputValue = e.currentTarget.value;

                if (key === 38) {
                    me.update('MoveUp', inputValue);
                } else if (key === 40) {
                    me.update('MoveDown', inputValue);
                } else if (key === 13) {
                    me.update('OnReturnPressed');
                } else if (key === 9) {
                    me.update('OnTab', e);
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
                x.style.fontWeight = '400';
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
                me.searchInput.prop('disabled', true);
                if (me.toggleButton) me.toggleButton.removeClass('is-active');
            } else {
                me.searchForm.toggleClass('is-visible');
                me.searchInput.prop('disabled', false);
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
